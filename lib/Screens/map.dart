import 'dart:async';
import 'dart:convert';

import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/helpers/image_to_bytes.dart';
import 'package:app1f/models/locationmodel.dart';
import 'package:app1f/network/api_weather.dart';
import 'package:app1f/widgets/LocationListWidget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Map_Screen extends StatefulWidget {
  const Map_Screen({super.key});

  @override
  State<Map_Screen> createState() => _Map_ScreenState();
}

class _Map_ScreenState extends State<Map_Screen> {
  AgendaDB? agendaDB;
  ApiWeather? apiWeather;
  final List<MapType> mapas = [
    MapType.normal,
    MapType.satellite,
    MapType.terrain,
    MapType.hybrid,
  ];
  int identifiermap = 0;

  TextEditingController nameubicacionController = TextEditingController();
  Map<MarkerId, Marker> _markers = {};
  late Uri link;
  Set<Marker> get markers => _markers.values.toSet();

  ValueNotifier<int> optMap = ValueNotifier<int>(0);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    apiWeather = ApiWeather();
    agendaDB!.GET_LOCATIONS().then((value) {
      value.map((e) async {
        var markId = MarkerId(e['idLocation']);
        var name = Marker(
          markerId: markId,
          position: LatLng(e['lat'], e['lon']),
          icon: await apiWeather!.getIcon(e['lat'], e['lon']),
        );
        if (!_markers.containsKey('Iam') && e['idLocation'] != 'YO') {
          _markers[markId] = name;
        }
      }).forEach((element) {});
    });
  }

  Future<Position> location() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await agendaDB!.UPDATE('tblClima', 'idLocation', {
      'idLocation': 'YO',
      'lat': posicion.latitude,
      'lon': posicion.longitude,
      'name': 'Mi Ubicación'
    });
    const markId = MarkerId('Iam');
    final marker = Marker(
        markerId: markId,
        icon: await apiWeather!.getIcon(posicion.latitude, posicion.longitude),
        position: LatLng(posicion.latitude, posicion.longitude));
    if (!_markers.containsKey('Iam')) {
      _markers[markId] = marker;
    }
    return posicion;
  }

  @override
  Widget build(BuildContext context) {
    final ActionChip opNormal = ActionChip(
      label: const Text(
        'Normal',
        style: TextStyle(color: Colors.white),
      ),
      avatar: const CircleAvatar(
        backgroundColor: Colors.amber,
        child: Icon(Icons.map),
      ),
      onPressed: () {
        GlobalValues.optMap.value = 0;
        identifiermap = 0;
      },
      backgroundColor: Colors.black87,
    );
    final ActionChip opSatellite = ActionChip(
      label: const Text(
        'Satellite',
        style: TextStyle(color: Colors.white),
      ),
      avatar: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.satellite_alt_outlined),
      ),
      onPressed: () {
        GlobalValues.optMap.value = 1;
        identifiermap = 1;
      },
      backgroundColor: Colors.black87,
    );
    final ActionChip opTerrain = ActionChip(
      label: const Text(
        'Terrain',
        style: TextStyle(color: Colors.white),
      ),
      avatar: const CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(Icons.terrain_sharp),
      ),
      onPressed: () {
        GlobalValues.optMap.value = 2;
        identifiermap = 2;
      },
      backgroundColor: Colors.black87,
    );
    final ActionChip opHybrid = ActionChip(
      label: const Text(
        'Hybrid',
        style: TextStyle(color: Colors.white),
      ),
      avatar: const CircleAvatar(
        backgroundColor: Colors.purple,
        child: Icon(Icons.troubleshoot_sharp),
      ),
      onPressed: () {
        GlobalValues.optMap.value = 3;
        identifiermap = 3;
      },
      backgroundColor: Colors.black87,
    );
    return FutureBuilder(
        future: location(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Weather Map'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.list),
                    tooltip: 'Locations List',
                  )
                ],
              ),
              body: Stack(
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.bottomLeft,
                children: [
                  ValueListenableBuilder(
                      valueListenable: GlobalValues.optMap,
                      builder: ((context, value, child) {
                        return GoogleMap(
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(snapshot.data!.latitude,
                                  snapshot.data!.longitude),
                              zoom: 30),
                          mapType: mapas[value],
                          markers: markers,
                          onMapCreated: (controller) {
                            _controller.complete(controller);
                          },
                          onTap: (position) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        const Text('Agregar Nueva Ubicación'),
                                    content: Container(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Ingresa el nombre de la nueva ubicación',
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Flexible(
                                            child: TextFormField(
                                              controller:
                                                  nameubicacionController,
                                              decoration: const InputDecoration(
                                                  label: Text('Locación'),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: const Text('Cancelar')),
                                      ElevatedButton(
                                          onPressed: () async {
                                            final markId = MarkerId(position
                                                    .latitude
                                                    .toString() +
                                                position.longitude.toString());
                                            final marker = Marker(
                                                markerId: markId,
                                                position: LatLng(
                                                    position.latitude,
                                                    position.longitude),
                                                icon: await apiWeather!.getIcon(
                                                    position.latitude,
                                                    position.longitude));
                                            _markers[markId] = marker;
                                            agendaDB!.INSERT('tblClima', {
                                              'idLocation': position.latitude
                                                      .toString() +
                                                  position.longitude.toString(),
                                              'name':
                                                  nameubicacionController.text,
                                              'lon': position.longitude,
                                              'lat': position.latitude,
                                            }).then((value) {
                                              var msj = (value > 0)
                                                  ? "La insercción fue exitosa"
                                                  : "Ocurrio un error";
                                              var snackbar =
                                                  SnackBar(content: Text(msj));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar);
                                              Navigator.pop(context);
                                            });
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          child: const Text('Aceptar')),
                                    ],
                                  );
                                });

                            setState(() {});
                          },
                        );
                      })),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      opNormal,
                      opSatellite,
                      opTerrain,
                      opHybrid
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: GlobalValues.optMap,
                    builder: (context, value, child) {
                      return DraggableScrollableSheet(
                          initialChildSize: 0.1,
                          minChildSize: 0.1,
                          maxChildSize: 0.4,
                          builder: (BuildContext context, scroollcontroller) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(30.0)),
                              child: Container(
                                  color: Colors.blueGrey,
                                  child: Expanded(
                                    child: ValueListenableBuilder(
                                        valueListenable:
                                            GlobalValues.flagLoction,
                                        builder: (context, value, _) {
                                          return FutureBuilder(
                                              future:
                                                  agendaDB!.GETALLLOCATIONS(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          List<LocationModel>>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                    controller:
                                                        scroollcontroller,
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    itemBuilder:
                                                        (BuildContext context1,
                                                            int index) {
                                                      return LocationListWidget(
                                            
                                                        locationmodel: snapshot
                                                            .data![index],
                                                        agendaDB: agendaDB,
                                                        markers: _markers,
                                                        identifiermap:
                                                            identifiermap,
                                                        
                                                      );
                                                    },
                                                    
                                                  );
                                                } else {
                                                  return const Text(
                                                      'Sin elementos registrados');
                                                }
                                              });
                                        }),
                                  )),
                            );
                          });
                    },
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Error al cargar la ubicación del usuario'),
            );
          }
        });
  }
}
// e1af65951dff47bbf181fdc20d075cbe
