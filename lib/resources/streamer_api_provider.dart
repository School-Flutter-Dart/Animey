import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:animey/models/streamer.dart';
import 'package:animey/utils/http_utils.dart';

class StreamerApiProvider {
  Client client = Client();

  Future<Streamer> fetchStreamer(String streamingLinkId) async{
    var response = await client.get("https://kitsu.io/api/edge/streaming-links/$streamingLinkId/streamer"); //here we first fetch streaming-links, [streamer] is nested inside streaming-links
    if(response.statusCode == 200){
      //call to the server was successful, parse the JSON
       return Streamer.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
    }else{
      throw Exception('Failed to load anime');
    }
  }
}