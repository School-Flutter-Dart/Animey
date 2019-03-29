import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:animey/models/anime.dart';
import 'package:animey/models/episode.dart';
import 'package:animey/models/library_entries.dart';
import 'package:animey/utils/http_utils.dart';

class AnimesApiProvider {
  Client client = Client();

  Future<List<Anime>> fetchAnimes(String link, {bool withOnlyPosterImage = false, int offset = 0}) async {
    link += link.contains('?') ? "&page[offset]=$offset" : "?page[offset]=$offset";
    if (withOnlyPosterImage) {
      link += "&fields[anime]=posterImage";
    }
    final response = await client.get(link);
    if (response.statusCode == 200) {
      print("fetched animes");
      //call to the server was successful, parse the JSON
      var list = (convertToUtf8Json(response.bodyBytes)['data'] as List).map((json) => Anime.fromJson(json)).toList();
      print(list.first.attributes.canonicalTitle);
      return list;
    } else {
      throw Exception('Failed to load animes');
    }
  }

  //https://kitsu.io/api/edge/categories/60/anime
  Future<List<Anime>> fetchAnimesByCatrgoryId(String categoryId, {bool withOnlyPosterImage = false, int offset = 0}) async {
    String link = "https://kitsu.io/api/edge/categories/$categoryId/anime?page[offset]=$offset";
    if (withOnlyPosterImage) {
      link += "&fields[anime]=posterImage";
    }
    final response = await client.get(link);
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      var list = (convertToUtf8Json(response.bodyBytes)['data'] as List).map((json) => Anime.fromJson(json)).toList();
      return list;
    } else {
      throw Exception('Failed to load animes by category id');
    }
  }
  
  Future<List<Anime>> fetchAnimesByStreamerId(String streamerId, {int offset = 0}) async {
    var resposne = await client.get("https://kitsu.io/api/edge/streamers/$streamerId/streaming-links?include=media&page[offset]=$offset"); //we first fetch the animeId
    var animeIds = (convertToUtf8Json(resposne.bodyBytes)['data'] as List).map((streamingLink){
      return streamingLink['relationships']['media']['data']['id'];
    }).toList();
    var animes = List<Anime>();
    for(String animeId in animeIds){
      animes.add(await fetchAnimeById(animeId, filterStr: "?fields[anime]=posterImage,titles,startDate,episodeCount,episodeLength,canonicalTitle"));
    }
    
    return animes;
  }

  Future<Anime> fetchAnimeById(String animeId, {String filterStr}) async {
    final response = await client.get("https://kitsu.io/api/edge/anime/$animeId"+(filterStr??""));
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      return Future(() {
        return Anime.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
      });
    } else if(response.statusCode == 404){
      return null;
    }else{
      print("https://kitsu.io/api/edge/anime/$animeId");
      print(animeId);
      throw Exception('Failed to load anime by Id');
    }
  }

  Future<Anime> fetchAnime(String link, {String filterStr=""}) async {
    final response = await client.get(link+filterStr);
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      return Future(() {
        var json = convertToUtf8Json(response.bodyBytes)['data'];
        if(json != null) return Anime.fromJson(json);
        else return null;
      });
    } else {
      throw Exception('Failed to load anime');
    }
  }

  Future<List<Anime>> fetchTrendingAnimes() async {
    print("fetching trending animes");
    final response = await client.get("https://kitsu.io/api/edge/trending/anime");
    if (response.statusCode == 200) {
      print("fetched trending animes");
      //call to the server was successful, parse the JSON
      var list = (convertToUtf8Json(response.bodyBytes)['data'] as List).map((json) => Anime.fromJson(json)).toList();
      print(list.first.attributes.canonicalTitle);
      return list;
    } else {
      throw Exception('Failed to load trending animes');
    }
  }

  Future<List<Anime>> fetchFiteredAnimes(String filterStr, int offset) async {
    final response = await client.get("https://kitsu.io/api/edge/anime?page[offset]=$offset$filterStr");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      return Future(() {
        return (convertToUtf8Json(response.bodyBytes)['data'] as List).map((json) => Anime.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load filtered animes');
    }
  }

  Future<List<Episode>> fetchEpisodesByAnimeId(String animeId, {int offset = 0}) async {
    final response = await client.get("https://kitsu.io/api/edge/anime/$animeId/episodes?page[offset]=$offset");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      return Future(() {
        return (convertToUtf8Json(response.bodyBytes)['data'] as List).map((json) => Episode.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load load episodes');
    }
  }

  @Deprecated("avoid using this shit, messy as hell")
  Future<List<Anime>> fetchAnimesFromLibraryEntries(List<LibraryEntry> libraryEntries) async {
    var animes = List<Anime>();
    for (var entry in libraryEntries) {
      print(entry.relationships.anime.related + "?fields[anime]=posterImage,titles,startDate,episodeCount,episodeLength,canonicalTitle");
      var response = await client
          .get(entry.relationships.anime.related + "?fields[anime]=posterImage,titles,startDate,episodeCount,episodeLength,canonicalTitle");
      animes.add(Anime.fromJson(convertToUtf8Json(response.bodyBytes)['data']));
    }
    return animes;
  }

  @Deprecated("avoid using this shit, messy as hell")
  Future<Anime> fetchAnimeFromLibraryEntry(LibraryEntry libraryEntry, bool withOnlyPosterImage) async {
    String link = libraryEntry.relationships.anime.related;
    if (withOnlyPosterImage) {
      link += "?fields[anime]=posterImage";
    }
    var response = await client.get(link);
    return Anime.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
  }

  @Deprecated("avoid using this shit, messy as hell")
  Future<Anime> fetchBriefAnimeFromLibraryEntry(LibraryEntry libraryEntry) async {
    var response = await client
        .get(libraryEntry.relationships.anime.related + "?fields[anime]=posterImage,titles,startDate,episodeCount,episodeLength,canonicalTitle");
    return Anime.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
  }

  @Deprecated("avoid using this shit, messy as hell")
  Future<Map<LibraryEntry, Anime>> fetchLibraryEntryToAnimeMap(List<LibraryEntry> libraryEntries) async {
    return Map.fromIterables(libraryEntries, await fetchAnimesFromLibraryEntries(libraryEntries));
  }
}
