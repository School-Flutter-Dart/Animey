import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'dart:convert';
import 'package:animey/models/user.dart';
import 'package:animey/utils/http_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'string_values.dart';


class UserInfoApiProvider {
  Client client = Client();

  Future<User> fetchUserAvatarByLink(String link) async {
    final response = await client.get(link+"?fields[users]=avatar");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      return User.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
    } else {
      throw Exception('Failed to load user avatar by link');
    }
  }

  Future<User> fetchUserInfoByLink(String link) async {
    final response = await client.get(link);
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      return User.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
    } else {
      throw Exception('Failed to load user info by link');
    }
  }

  Future<User> fetchUserInfoById(String userId) async {
    var response = await client.get("https://kitsu.io/api/edge/users/$userId");
    var sharedPreferences = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      var user = User.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
      var authedUserId = sharedPreferences.getString(UserId);
      if(authedUserId != null && userId != authedUserId){
        return Future<User>(() async{
          await client.get("https://kitsu.io/api/edge/follows?filter%5Bfollower%5D=$authedUserId&filter%5Bfollowed%5D=$userId").then((response){
            if(convertToUtf8Json(response.bodyBytes)['meta']['count']==0)
              user.isFollowed = false;
            else
              user.isFollowed = true;
          });
          print("the bool is ${user.isFollowed}");
          return user;
        });
      }else{
        return user;
      }

    } else {
      throw Exception('Failed to load user info by user id');
    }
  }

  Future<String> fetchLoggedInUserId() async {
    var url = "https://kitsu.io/api/edge/users?filter[self]=true&fields[users]=id";
    var request = Request('GET', Uri.parse(url));
    var sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString(AccessToken);
    if(accessToken == null) throw Exception("access_token is null");
    request.headers["Authorization"] =
    "Bearer $accessToken";
    request.headers["Content-Type"] = "application/vnd.api+json";

    var streamResponse = await client.send(request);
    var strResponse = await streamResponse.stream.bytesToString();
    print(strResponse);
    var json = jsonDecode(strResponse);
    return json['data'].first['id'];
  }

  Future<User> fetchLoggedInUserInfo() async {
    var url = "https://kitsu.io/api/edge/users?filter[self]=true";
    var request = Request('GET', Uri.parse(url));
    var sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString(AccessToken);
    if(accessToken == null) throw Exception("access_token is null");
    request.headers["Authorization"] =
    "Bearer $accessToken";
    request.headers["Content-Type"] = "application/vnd.api+json";


    var streamResponse = await client.send(request);
    var strResponse = await streamResponse.stream.bytesToString();
    print(strResponse);
    var json = jsonDecode(strResponse);
    return User.fromJson(json['data'].first);
  }

  ///if success, then returns the follow Id
  Future<String> addFollow(String followedUserId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString(AccessToken);
    String userId = sharedPreferences.getString(UserId);
    if(accessToken != null && userId !=null) {
      var url = "https://kitsu.io/api/edge/follows";
      var request = Request('POST', Uri.parse(url));
      request.headers["Authorization"] =
      "Bearer $accessToken";
      request.headers["Content-Type"] = "application/vnd.api+json";
      request.body = '{"data":{"relationships":{"follower":{"data":{"type":"users","id":"$userId"}},"followed":{"data":{"type":"users","id":"$followedUserId"}}},"type":"follows"}}';
      var streamResponse = await client.send(request);
      var strResponse = await streamResponse.stream.bytesToString();
      print("$strResponse");
      return jsonDecode(strResponse)['data']['id'];
    }else return null;
  }

  void deleteFollow(String followId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString(AccessToken);
    String userId = sharedPreferences.getString(UserId);
    print("followId is : https://kitsu.io/api/edge/follows/$followId");
    if(accessToken != null && userId !=null) {
      print("followId is : https://kitsu.io/api/edge/follows/$followId");
      var url = "https://kitsu.io/api/edge/follows/$followId";
      var request = Request('POST', Uri.parse(url));
      request.headers["Authorization"] =
      "Bearer $accessToken";
      request.headers["Content-Type"] = "application/vnd.api+json";
      client.send(request);
    }
  }
}
