import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'string_values.dart';

class LoginApiProvider {
  final client = Client();
  ///returns bool if login failed
  ///username should be an email address
  ///response sample:  {"access_token":"7f3e1665d906aaca078d326f721d81af5814033379317645643042635e258de6",
  ///"token_type":"Bearer",
  ///"expires_in":2337463,
  ///"refresh_token":"445d8a001d80f53c5ea7b55b9c0378ec147ee5d7680d8cc167b9bcf66712be54",
  ///"scope":"public",
  ///"created_at":1551329248}
  Future<bool> handleLogin(String username, String password) async {
    var url = "https://kitsu.io/api/oauth/token";
    var request = Request('POST', Uri.parse(url));
    request.bodyFields = {
      'grant_type': 'password',
      'username': username,
      'password': password,
      //'client_id':'dd031b32d2f56c990b1425efe6c42ad847e7fe3ab46bf1299f05ecd856bdb7dd',
      //'CLIENT_SECRET': '54d7307928f63414defd96399fc31ba847961ceaecef3a5fd93144e960c0e151'
    };
    var streamResponse = await client.send(request);

    if (streamResponse.statusCode != 200)
      return false;
    else {
      _storeLoginInfo(
          await streamResponse.stream.bytesToString(), username, password);
      return true;
    }
  }

  _storeLoginInfo(String response, String username, String password) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var json = jsonDecode(response);
    sharedPreferences.setString(AccessToken, json[AccessToken]);
    sharedPreferences.setString(TokenType, json[TokenType]);
    sharedPreferences.setInt(ExpiresIn, json[ExpiresIn]);
    sharedPreferences.setString(RefreshToken, json[RefreshToken]);
    sharedPreferences.setString(Scope, json[Scope]);
    sharedPreferences.setInt(CreatedAt, json[CreatedAt]);
    sharedPreferences.setString(Username, username);
    sharedPreferences.setString(Password, password);

    var url = "https://kitsu.io/api/edge/users?filter[self]=true&fields[users]=id";
    var request = Request('GET', Uri.parse(url));
    String accessToken = sharedPreferences.getString(AccessToken);
    if(accessToken == null) throw Exception("access_token is null");
    request.headers["Authorization"] =
    "Bearer $accessToken";
    request.headers["Content-Type"] = "application/vnd.api+json";


    var streamResponse = await client.send(request);
    var strResponse = await streamResponse.stream.bytesToString();
    print(strResponse);
    json = jsonDecode(strResponse);
    sharedPreferences.setString(UserId, json['data'].first['id']);
  }
}
