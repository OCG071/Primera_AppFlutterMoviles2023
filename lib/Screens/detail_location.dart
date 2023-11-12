import 'package:app1f/models/locationmodel.dart';
import 'package:app1f/network/api_weather.dart';
import 'package:app1f/widgets/CardWeatherItem.dart';
import 'package:flutter/material.dart';

class DetailLocation extends StatefulWidget {
  const DetailLocation({super.key});
  // lat: 20.5409836, lon: -100.8121145
  // https://api.openweathermap.org/data/2.5/forecast?lat=20.5409836&lon=-100.8121145&appid=e1af65951dff47bbf181fdc20d075cbe&units=metric&lang=es
  @override
  State<DetailLocation> createState() => _DetailLocationState();
}

class _DetailLocationState extends State<DetailLocation> {
  LocationModel? location;
  ApiWeather? apiWeather;
  Map<String, dynamic> map = {};

  @override
  void initState() {
    apiWeather = ApiWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    location = ModalRoute.of(context)!.settings.arguments as LocationModel;
    print('lat: ${location!.lat}, lon: ${location!.lon}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(location!.name!),
      ),
      body: Container(
        color: const Color.fromRGBO(58, 71, 108, 1),
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: apiWeather!.getWeather(location!.lat!, location!.lon!),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var icono = snapshot.data['weather'][0]['icon'].toString();
              var temp =
                  snapshot.data['main']['temp'].toString().substring(0, 2);
              temp = temp.replaceAll(".", "");
              var tempMax =
                  snapshot.data['main']['temp_max'].toString().substring(0, 2);
              tempMax = tempMax.replaceAll(".", "");
              var tempMin =
                  snapshot.data['main']['temp_min'].toString().substring(0, 2);
              tempMin = tempMin.replaceAll(".", "");
              var feels = snapshot.data['main']['feels_like']
                  .toString()
                  .substring(0, 2);
              feels = feels.replaceAll(".", "");
              var humidity = snapshot.data['main']['humidity'].toString();
              var windS = snapshot.data['wind']['speed'].toString();
              var visibility = snapshot.data['visibility'] / 1000;
              var city = snapshot.data['name'].toString();
              var pressure = (snapshot.data['main']['pressure'] * 0.7501);
              var clouds = snapshot.data['clouds']['all'];
              pressure = pressure.round();
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200.0,
                    height: 200.0,
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        image: DecorationImage(
                          opacity: 0.8,
                          image: Image(
                            image: NetworkImage(
                                'https://openweathermap.org/img/wn/$icono.png'),
                          ).image,
                          fit: BoxFit.cover,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$temp°',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 100),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    snapshot.data['weather'][0]['description'],
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Máx: $tempMax°C\t Min: $tempMin°C',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/build.png'),
                      const SizedBox(
                        width: 7,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Ciudad: $city',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Table(
                    textDirection: TextDirection.ltr,
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/shirt.png'),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Sensación',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('$feels°C',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/water.png'),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Humedad',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('$humidity%',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/wind.png'),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Viento',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('$windS m/s',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                      const TableRow(children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                      TableRow(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/road.png'),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Visibilidad',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('$visibility km',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/clouds.png'),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Nubes',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('$clouds%',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/termo.png'),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Presión',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('$pressure mm',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 260,
                        color: const Color.fromRGBO(75, 114, 205, 1),
                        child: FutureBuilder(
                          future: apiWeather!
                              .getWeatherdays(location!.lat!, location!.lon!),
                          builder: (context,
                              AsyncSnapshot<Map<String, dynamic>?> shot) {
                            if (shot.hasData) {
                              var cant = shot.data!['cnt'] - 1;
                              return ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CasdWeather(
                                        data: shot.data!['list'][index]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(width: 5);
                                  },
                                  itemCount: cant);
                            } else {
                              return const Text('Error al cargar el forecast');
                            }
                          },
                        ),
                      ),
                    ],
                  )

                  /*Text(
                    snapshot.data['list'][0]['dt_txt'].toString()+'\n'+
                    snapshot.data['list'][8]['dt_txt'].toString()+'\n'+
                    snapshot.data['list'][24]['dt_txt'].toString()+'\n'
                    
                    ),*/
                ],
              );
            } else {
              return const Text('No c logro :(');
            }
          },
        ),
      ),
    );
    /*return FutureBuilder(
      future: apiWeather!.getWeatherdays(location!.lat!, location!.lon!), 
      builder: (context, AsyncSnapshot snapshot){
        if (snapshot.hasData) {
        }
      }
      )*/
  }
}
