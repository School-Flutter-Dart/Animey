import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:animey/models/anime.dart';
import 'package:animey/utils/http_utils.dart';

class AnimeApiProvider {
  Client client = Client();

  Future<Anime> fetchAnime(String id) async{
    final response = await client.get("https://kitsu.io/api/edge/animes/$id");
    if(response.statusCode == 200){
      //call to the server was successful, parse the JSON
      return Anime.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
    }else{
      throw Exception('Failed to load anime');
    }
  }
}