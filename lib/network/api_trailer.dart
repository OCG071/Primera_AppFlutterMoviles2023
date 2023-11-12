import 'package:app1f/models/trailersmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiTrailer {
  late Uri link; 

  Future<List<TrailerModel>?> getTrailer(int id) async {
    link = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/videos?api_key=f032ceb6227ace7cd176f038a213d2b5&language=es-MX&page=1%27)');
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['results'] as List;
      if (jsonResult.isEmpty) {
        link = Uri.parse(
            'https://api.themoviedb.org/3/movie/$id/videos?api_key=f032ceb6227ace7cd176f038a213d2b5');
        response = await http.get(link);
        if (response.statusCode == 200) {
          jsonResult = jsonDecode(response.body)['results'] as List;
        }
      }
      return jsonResult
          .map((trailer) => TrailerModel.fromMap(trailer))
          .toList();
    }
    return null;
  }
}
