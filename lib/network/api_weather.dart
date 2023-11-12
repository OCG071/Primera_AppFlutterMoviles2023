import 'package:app1f/helpers/image_to_bytes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app1f/models/castmodel.dart';

class ApiWeather {
  late Uri link;

  Future<BitmapDescriptor> getIcon(double lat, lon) async {
    var icon = BitmapDescriptor.fromBytes(await imageTobytes(
        'https://openweathermap.org/img/wn/10d.png',
        width: 130));
    link = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=e1af65951dff47bbf181fdc20d075cbe');
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonresI = jsonDecode(response.body)["weather"][0]["icon"].toString();
      icon = BitmapDescriptor.fromBytes(await imageTobytes(
          'https://openweathermap.org/img/wn/$jsonresI.png',
          width: 130));
    }
    return icon; 
  }

  Future<Map<String, dynamic>?> getWeather(double lat, lon) async {
    link = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=e1af65951dff47bbf181fdc20d075cbe&lang=es&units=metric');
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonresI = jsonDecode(response.body);
      return jsonresI;
    }
    return null;
  } 

    Future<Map<String,dynamic>?> getWeatherdays(double lat, lon) async {
    link = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=e1af65951dff47bbf181fdc20d075cbe&units=metric&lang=es');
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonresI = jsonDecode(response.body);
      return jsonresI;
    }
    return null;
  }

}

