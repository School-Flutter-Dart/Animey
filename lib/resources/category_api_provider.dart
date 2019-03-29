import 'dart:async';

import 'package:http/http.dart' show Client;
import 'package:animey/models/category.dart';
import 'package:animey/utils/http_utils.dart';

class CategoryApiProvider{
  final client = Client();

  Future<List<Category>> fetchCategoriesByAnimeId(String animeId) async {
    final response =
        await client.get("https://kitsu.io/api/edge/anime/$animeId/categories?fields[categories]=id,title,slug");
    if (response.statusCode == 200) {
      print(response.body);
      //call to the server was successful, parse the JSON
      return (convertToUtf8Json(response.bodyBytes)['data'] as List)
          .map((json) => Category.fromJson(json))
          .toList();
    } else {
      print("https://kitsu.io/api/edge/anime/$animeId/categories");
      print(animeId);
      throw Exception('Failed to load Category by Id');
    }
  }
}