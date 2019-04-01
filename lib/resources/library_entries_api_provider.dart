import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'package:animey/models/anime.dart';
import 'package:animey/models/library_entries.dart';
import 'package:animey/utils/http_utils.dart';
import 'package:animey/utils/model_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'string_values.dart';

class LibraryEntriesApiProvider {
  Client client = Client();

  Future<LibraryEntriesData> fetchLibraryEntriesDataByAnimeId(String userId, String animeId)async{
    String url = 'https://kitsu.io/api/edge/library-entries?filter%5Buser_id%5D=$userId&filter%5Banime_id%5D=$animeId&include=mediaReaction&page%5Blimit%5D=1';
    var response = await client.get(url);
    if(response.statusCode==200){
      var json = convertToUtf8Json(response.bodyBytes);
      var data = LibraryEntriesData.fromJson(json);
      return data;
    }else{
      throw Exception('Failed to load lbraryEntries data by anime id');
    }
  }

  Future<LibraryEntriesData> fetchLibraryEntriesData(String id) async {
    print("the link is https://kitsu.io/api/edge/users/$id/library-entries?filter[kind]=anime&include=anime");
    var response = await client.get(
        "https://kitsu.io/api/edge/users/$id/library-entries?filter[kind]=anime&include=anime");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      var json = convertToUtf8Json(response.bodyBytes);
      var data = LibraryEntriesData.fromJson(json);
      var animesJson = json['included'] as List;
      for(int i = 0;i< data.data.length;i++){
        data.data[i].anime = Anime.fromJson(animesJson[i]);
        //entry.anime = await AnimesApiProvider().fetchAnimeById(entry.relationships.animeId,filterStr: "?fields[anime]=posterImage,episodeCount,canonicalTitle");
      }
      if(data.meta.count >10){//means more than 10 get them all
        int offset = 10;
        while(true){
          response = await client.get(
              "https://kitsu.io/api/edge/users/$id/library-entries?filter[kind]=anime&include=anime&page[offset]=$offset");
          json = convertToUtf8Json(response.bodyBytes);
          var extra = LibraryEntriesData.fromJson(json);
          var animesJson = json['included'] as List;
          for(int i = 0;i< extra.data.length;i++){
            extra.data[i].anime = Anime.fromJson(animesJson[i]);
            //entry.anime = await AnimesApiProvider().fetchAnimeById(entry.relationships.animeId,filterStr: "?fields[anime]=posterImage,episodeCount,canonicalTitle");
          }
          data.data.addAll(extra.data);
          if(offset>data.meta.count) {
            break;
          }
          else offset+=10;
        }
        return data;
      }else{
        return data;
      }
    } else {
      print(id);
      throw Exception('Failed to load lbraryEntries data');
    }
  }

  Stream<List<LibraryEntry>> fetchLibraryEntries(String id) async* {
    print("the link is https://kitsu.io/api/edge/users/$id/library-entries?filter[kind]=anime&include=anime");
    var response = await client.get(
        "https://kitsu.io/api/edge/users/$id/library-entries?filter[kind]=anime&include=anime");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      var json = convertToUtf8Json(response.bodyBytes);
      var data = LibraryEntriesData.fromJson(json);
      var animesJson = json['included'] as List;
      for(int i = 0;i< data.data.length;i++){
        data.data[i].anime = Anime.fromJson(animesJson[i]);
        //entry.anime = await AnimesApiProvider().fetchAnimeById(entry.relationships.animeId,filterStr: "?fields[anime]=posterImage,episodeCount,canonicalTitle");
      }
      yield data.data;
      if(data.meta.count >10){//means more than 10 get them all
        int offset = 10;
        while(true){
          response = await client.get(
              "https://kitsu.io/api/edge/users/$id/library-entries?filter[kind]=anime&include=anime&page[offset]=$offset");
          json = convertToUtf8Json(response.bodyBytes);
          var extra = LibraryEntriesData.fromJson(json);
          var animesJson = json['included'] as List;
          for(int i = 0;i< extra.data.length;i++){
            extra.data[i].anime = Anime.fromJson(animesJson[i]);
            //entry.anime = await AnimesApiProvider().fetchAnimeById(entry.relationships.animeId,filterStr: "?fields[anime]=posterImage,episodeCount,canonicalTitle");
          }
          yield extra.data;
          //data.data.addAll(extra.data);
          if(offset>data.meta.count) {
            break;
          }
          else offset+=10;
        }
        //return data;
      }else{
        //yield data.data;
      }
    } else {
      print(id);
      throw Exception('Failed to load lbraryEntries data');
    }
  }

  Future removeLibraryEntry(String entryId) async {}

  Future addLibraryEntry(String animeId, Status status) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString(UserId);
    var accessToken = sharedPreferences.getString(AccessToken);
    print("user id is $userId");
    if(userId!=null){
      print("user is not null");
      var url = "https://kitsu.io/api/edge/library-entries";
      var deleteRequest = Request('DELETE', Uri.parse(url));
      var client = Client();
      client.send(deleteRequest).then((res) =>
          res.stream.bytesToString().then((val) => print(val.toString())));
      var request = Request('POST', Uri.parse(url));
      var bodyStr =
          '{"data":{"type":"libraryEntries","attributes":{"status":"${statusToRequesetStringConverter(status)}"},"relationships":{"user": {"data": {"type": "users", "id": "$userId"}},"anime":{"data":{"type":"anime","id":"$animeId"}}}}}';
      request.headers["Authorization"] =
      "Bearer $accessToken"; 
      request.headers["Content-Type"] = "application/vnd.api+json";
      request.body = bodyStr;

      return client
          .send(request)
          .then((response) => response.stream.bytesToString().then((value) {
            print("--------added to library, inside addLibraryEntry--------");
        print(value.toString());
      }))
          .catchError((error) {
        print(error.toString());
      }).whenComplete(() {
        return;
      });
    }
  }
}
