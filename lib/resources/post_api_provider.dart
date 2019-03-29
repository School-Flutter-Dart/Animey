import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'animes_api_provider.dart';
import 'package:animey/models/post.dart';
import 'package:animey/models/comment.dart';
import 'package:animey/models/upload.dart';
import 'package:animey/utils/http_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'string_values.dart';
import 'package:animey/models/user.dart';
import 'user_api_provider.dart';

class PostApiProvider {
  Client client = Client();
  final animesApiProvider = AnimesApiProvider();

  Future<Post> fetchPostByPostId(String postId) async {
    final response = await client.get("https://kitsu.io/api/edge/posts/$postId");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      return Post.fromJson(convertToUtf8Json(response.bodyBytes)['data']);
    } else {
      throw Exception('Failed to load post id');
    }
  }

  Stream<Post> fetchPostsByAnimeId(String animeId,{int offset = 0}) async* {
    final url =
        'https://kitsu.io/api/edge/feeds/media_aggr/Anime-$animeId?include=media%2Cactor%2Cunit%2Csubject%2Ctarget%2Ctarget.user%2Ctarget.target_user%2Ctarget.spoiled_unit%2Ctarget.media%2Ctarget.target_group%2Ctarget.uploads%2Csubject.user%2Csubject.target_user%2Csubject.spoiled_unit%2Csubject.media%2Csubject.target_group%2Csubject.uploads%2Csubject.followed%2Csubject.library_entry%2Csubject.anime%2Csubject.manga&page%5Blimit%5D=10';
    final response = await client.get(url);
    if(response.statusCode == 200){
      var json = convertToUtf8Json(response.bodyBytes);
      var postJsons = (json['included'] as List).where((json)=>json['type']=='posts').toList();
      var userJsons = (json['included'] as List).where((json)=>json['type']=='users').toList();
      var uploadJsons = (json['included'] as List).where((json)=>json['type']=='uploads').toList();
      for(var postJson in postJsons){
        Post post = Post.fromJson(postJson);
        post.user = User.fromJson(userJsons.singleWhere((json)=>json['id']==post.relationships.userId));
        for(var uploadId in post.relationships.uploadIds){
          post.uploads.add(Upload.fromJson(uploadJsons.singleWhere((json)=>json['id']==uploadId)));
        }
        yield post;
      }
    }
  }

  Future<List<Post>> fetchPosts({int offset = 0}) async {
    final response = await client.get("https://kitsu.io/api/edge/posts?sort=-createdAt&page[offset]=$offset&include=user");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      var json = convertToUtf8Json(response.bodyBytes);
      var posts = (json['data'] as List).map((json) => Post.fromJson(json)).toList();
      var users = (json['included'] as List).map((json) => User.fromJson(json)).toList();
      for (var post in posts) {
        var anime = await animesApiProvider.fetchAnime("https://kitsu.io/api/edge/posts/${post.id}/media",
            filterStr: "?fields[anime]=id,posterImage,titles,startDate,episodeCount,episodeLength,canonicalTitle");
        var uploads = await fetchUploads(post.id);
        post.anime = anime ?? null; //media can be manga
        post.uploads = uploads;
        post.user = users.singleWhere((user) => post.relationships.userId == user.id);
      }
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Stream<Post> fetchPost({int offset = 0}) async* {
    final response = await client.get("https://kitsu.io/api/edge/posts?sort=-createdAt&page[offset]=$offset&include=user").catchError((exception) {
      throw Exception();
    });
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      var json = convertToUtf8Json(response.bodyBytes);
      var posts = (json['data'] as List).map((json) => Post.fromJson(json)).toList();
      var users = (json['included'] as List).map((json) => User.fromJson(json)).toList();
      for (var post in posts) {
        var anime = await animesApiProvider.fetchAnime("https://kitsu.io/api/edge/posts/${post.id}/media",
            filterStr: "?fields[anime]=id,posterImage,titles,startDate,episodeCount,episodeLength,canonicalTitle");
        var uploads = await fetchUploads(post.id);
        post.anime = anime ?? null; //media can be manga
        post.uploads = uploads;
        post.user = users.singleWhere((user) => post.relationships.userId == user.id);
        yield post;
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }

  String nextUrl;
  Stream<Post> fetchFeedPost({int offset = 0}) async* {
    UserInfoApiProvider userInfoApiProvider = UserInfoApiProvider();
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(AccessToken) != null) {
      String accessToken = sharedPreferences.getString(AccessToken);
    //  String userId = sharedPreferences.getString(UserId);
//      final response = await client.head("https://kitsu.io/api/edge/feeds/timeline/$userId?filter[kind]=posts",
//          headers: {"Authorization": "Bearer $accessToken", "Content-Type": "application/vnd.api+json"});
      var url =
          "https://kitsu.io/api/edge/feeds/timeline/460584?sort=-createdAt&filter%5Bkind%5D=posts&include=media%2Cactor%2Cunit%2Csubject%2Ctarget%2Ctarget.user%2Ctarget.target_user%2Ctarget.spoiled_unit%2Ctarget.media%2Ctarget.target_group%2Ctarget.uploads%2Csubject.user%2Csubject.target_user%2Csubject.spoiled_unit%2Csubject.media%2Csubject.target_group%2Csubject.uploads%2Csubject.followed%2Csubject.library_entry%2Csubject.anime%2Csubject.manga&page%5Blimit%5D=10";
      if (nextUrl != null && nextUrl.isNotEmpty && offset != 0) {
        print('reached ygkufkyfku');
        url = nextUrl;
      }
      var request = Request('GET', Uri.parse(url));
      request.headers["Authorization"] = "Bearer $accessToken";
      request.headers["Content-Type"] = "application/vnd.api+json";
      var response = await client.send(request);
      if (response.statusCode == 200) {
        //call to the server was successful, parse the JSON
        var json = convertToUtf8Json(await response.stream.toBytes());
        nextUrl = json['links']['next'];

        var posts = (json['included'] as List).where((json) => json["type"] == "posts").map((json) async {
          var post = Post.fromJson(json);
          post.user = await userInfoApiProvider.fetchUserInfoById(json['relationships']['user']['data']['id']);
          return post;
        }).toList();
        //var users = (json['included'] as List).map((json) => User.fromJson(json)).toList();
        for (var p in posts) {
          var post = await p;
          var anime = await animesApiProvider.fetchAnime("https://kitsu.io/api/edge/posts/${post.id}/media",
              filterStr: "?fields[anime]=id,posterImage,titles,startDate,episodeCount,episodeLength,canonicalTitle");
          var uploads = await fetchUploads(post.id);
          post.anime = anime ?? null; //media can be manga
          post.uploads = uploads;

          yield post;
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } else {
      yield null;
    }
  }

  ///{"data":{"relationships":{"user":{"data":{"type":"users","id":"460584"}},"post":{"data":{"type":"posts","id":"9067155"}}},"type":"post-likes"}}
  uploadPostLike(String postId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(AccessToken) != null) {
      String accessToken = sharedPreferences.getString(AccessToken);
      String userId = sharedPreferences.getString(UserId);
      var url = "https://kitsu.io/api/edge/comments";
      var request = Request('POST', Uri.parse(url));
      var bodyStr =
          '{"data":{"relationships":{"user":{"data":{"type":"users","id":"$userId"}},"post":{"data":{"type":"posts","id":"$postId"}}},"type":"post-likes"}}';
      request.headers["Authorization"] = "Bearer $accessToken";
      request.headers["Content-Type"] = "application/vnd.api+json";
      request.body = bodyStr;
      client
          .send(request)
          .then((response) => response.stream.bytesToString().then((value) {
                print(value.toString());
              }))
          .catchError((error) {
        //print(error.toString());
      });
    }
  }

  ///{"data":{"attributes":{"content":"test"},"relationships":{"post":{"data":{"type":"posts","id":"9067155"}},"user":{"data":{"type":"users","id":"460584"}}},"type":"comments"}}
  Future<Comment> uploadComment(String postId, String content) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(AccessToken) != null) {
      String accessToken = sharedPreferences.getString(AccessToken);
      String userId = sharedPreferences.getString(UserId);
      var url = "https://kitsu.io/api/edge/comments";
      var request = Request('POST', Uri.parse(url));
      var bodyStr =
          '{"data":{"attributes":{"content":"$content"},"relationships":{"post":{"data":{"type":"posts","id":"$postId"}},"user":{"data":{"type":"users","id":"$userId"}}},"type":"comments"}}';
      request.headers["Authorization"] = "Bearer $accessToken";
      request.headers["Content-Type"] = "application/vnd.api+json";
      request.body = bodyStr;
      var streamResponse = await client.send(request);
      var bytes = await streamResponse.stream.toBytes();

      return Comment.fromJson(convertToUtf8Json(bytes)['data']);
    } else {
      return null;
    }
  }

  Stream<Comment> fetchComments(String postId, {int offset = 0}) async* {
    final response = await client.get("https://kitsu.io/api/edge/posts/$postId/comments?sort=-createdAt&page[offset]=$offset");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      var list = convertToUtf8Json(response.bodyBytes)['data'] as List;
      if (list.isEmpty && offset == 0) {
        yield null; //No comments
      }
      for (var json in list) {
        yield Comment.fromJson(json);
      }
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<List<Upload>> fetchUploads(String postId) async {
    final response = await client.get("https://kitsu.io/api/edge/posts/$postId/uploads");
    if (response.statusCode == 200) {
      //call to the server was successful, parse the JSON
      var list = (convertToUtf8Json(response.bodyBytes)['data'] as List).map((json) => Upload.fromJson(json)).toList();
      return list;
    } else {
      throw Exception('Failed to load uploads');
    }
  }
}
