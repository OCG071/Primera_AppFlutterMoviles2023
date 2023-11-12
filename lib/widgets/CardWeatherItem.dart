import 'package:flutter/material.dart';

class CasdWeather extends StatelessWidget {
  CasdWeather({super.key, required this.data});

  Map<String, dynamic>? data;

  String getDay(int dia) {
    switch (dia) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sabado';
      case 7:
        return 'Domingo';
      default:
        return 'Muy gracioso';
    }
  }

  @override
  Widget build(BuildContext context) {
    var temp = data!['main']['temp'].toString().substring(0, 2);
    temp = temp.replaceAll(".", "");
    var min = data!['main']['temp_min'].toString().substring(0, 2);
    var max = data!['main']['temp_max'].toString().substring(0, 2);
    var fecha = data!['dt_txt'].toString();
    DateTime date = DateTime.parse(fecha);
    var dia = getDay(date.weekday);
    var hora = fecha.substring(11, 16);
    var dianum = fecha.substring(8, 10);

    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromRGBO(52, 46, 101, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                'https://openweathermap.org/img/wn/${data!['weather'][0]['icon']}.png'),
          ),
          const SizedBox(height: 5),
          Text('$temp°',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('$dia $dianum',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(hora,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_upward_sharp,
                color: Colors.green,
              ),
              Text('$max°C',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 5,
              ),
              const Icon(Icons.arrow_downward_sharp, color: Colors.red),
              Text('$min°C',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ],
      ),
    );
  }
}
