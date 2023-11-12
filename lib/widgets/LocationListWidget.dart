// ignore: file_names
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/locationmodel.dart';
import 'package:app1f/network/api_weather.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class LocationListWidget extends StatefulWidget {
  LocationListWidget(
      {super.key,
      required this.locationmodel,
      this.agendaDB,
      required this.markers,
      this.identifiermap});

  Map<MarkerId, Marker> markers;
  LocationModel locationmodel;
  AgendaDB? agendaDB;
  int? identifiermap;

  @override
  State<LocationListWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<LocationListWidget> {
  LocationModel? location;
  ApiWeather? apiWeather;
  Map<MarkerId, Marker>? markers;
  Map<String, dynamic> map = {};
  var temp = '';

  @override
  void initState() {
    super.initState();
    apiWeather = ApiWeather();
    apiWeather!
        .getWeather(widget.locationmodel.lat!, widget.locationmodel.lon!)
        .then((value) {
      print('VALOR!!!!!!!!:  ${value!['weather'][0]['icon']}');
      temp = value['main']['temp'].toString().substring(0, 2);
      temp = temp.replaceAll(".", "");
      map.addAll({'icon': value['weather'][0]['icon'].toString()});
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print(map);
    var icono = widget.locationmodel.idLocation;
    return ListTile(
      contentPadding: EdgeInsets.only(top: 10),
      tileColor: Colors.white,
      leading: Container(
        height: 200,
        child: CachedNetworkImage(
          imageUrl: 'https://openweathermap.org/img/wn/${map!['icon']}.png',
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error_outline),
          height: 150,
        ),
      ),
      title: Text(widget.locationmodel.name!),
      subtitle: Text('Temperatura actual: $temp°C'),
      trailing: (icono != 'YO')
          ? IconButton(
              icon: Icon(Icons.favorite),
              color: const Color.fromRGBO(233, 30, 99, 1),
              onPressed: () {
                widget.markers.remove(widget.locationmodel.idLocation!);
                print('id: ${widget.locationmodel.idLocation}');
                widget.agendaDB!
                    .DELETE_STRING('tblClima', 'idLocation',
                        widget.locationmodel.idLocation!)
                    .then((value) {
                  GlobalValues.flagLoction.value =
                      !GlobalValues.flagLoction.value;
                  GlobalValues.optMap.value = widget.identifiermap!;
                  print('markers: $markers.');
                  print('markers widget: ${widget.markers.keys}');
                });
              })
          : null,
      onTap: () {
        Navigator.pushNamed(context, '/detaillocation',
            arguments: widget.locationmodel);
      },
    );
  }
}
