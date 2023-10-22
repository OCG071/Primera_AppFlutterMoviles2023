import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app1f/models/castmodel.dart';

class ApiCast{
  late Uri link;

  Future<List<CastModel>?> getCast(int id) async {
    link = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=f032ceb6227ace7cd176f038a213d2b5');
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['cast'] as List;
      return jsonResult
          .map((cast) => CastModel.fromMap(cast))
          .toList();
    }
    return null;
  }
}