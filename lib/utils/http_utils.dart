import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Future<String> getRequest(String url) async {
  final response = await http.get(url);
  final bodyBytes = response.bodyBytes;

  return Utf8Decoder().convert(bodyBytes);
}

Future<Map> getRequestAsJson(String url) async {
  final responseStr = await getRequest(url);
  return jsonDecode(responseStr);
}

Map convertToUtf8Json(Uint8List list){
  return jsonDecode(Utf8Decoder().convert(list));
}

Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: false);
  } else {
    throw 'Could not launch $url';
  }
}