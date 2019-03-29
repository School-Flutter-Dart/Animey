import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:animey/models/streamer.dart';
import 'package:animey/models/streaming_link.dart';
import 'package:animey/utils/http_utils.dart';

class StreamingLinkApiProvider {
  Client client = Client();

  Future<List<StreamingLink>> fetchStreamingLinksByAnimeId(String animeId) async{
    var response = await client.get("https://kitsu.io/api/edge/anime/$animeId/streaming-links"); //here we first fetch streaming-links, [streamer] is nested inside streaming-links
    if(response.statusCode == 200){
      //call to the server was successful, parse the JSON
      var streamingLinks = (convertToUtf8Json(response.bodyBytes)['data'] as List).map((json)=>StreamingLink.fromJson(json)).toList();
      for(var link in streamingLinks){
        var response = await client.get("https://kitsu.io/api/edge/streaming-links/${link.id}/streamer");
        link.streamer = Streamer.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
      }
      return streamingLinks;
    }else if(response.statusCode == 404){
      return List<StreamingLink>();
    }else{
      throw Exception('Failed to load streaminglinks by animeId through link: https://kitsu.io/api/edge/anime/$animeId/streaming-links');
    }
  }
}