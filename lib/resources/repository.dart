import 'dart:async';
import 'animes_api_provider.dart';
import 'category_api_provider.dart';
import 'post_api_provider.dart';
import 'streaming_links_api_provider.dart';
import 'user_api_provider.dart';
import 'library_entries_api_provider.dart';
import 'login_api_provider.dart';
import 'groups_api_provider.dart';
import 'package:animey/models/anime.dart';
import 'package:animey/models/episode.dart';
import 'package:animey/models/user.dart';
import 'package:animey/models/library_entries.dart';
import 'package:animey/models/category.dart';
import 'package:animey/models/comment.dart';
import 'package:animey/models/post.dart';
import 'package:animey/models/streaming_link.dart';
import 'package:animey/models/group_member.dart';

class Repository {
  final categoryApiProvider = CategoryApiProvider();
  final userInfoApiProvider = UserInfoApiProvider();
  final libraryEntriesApiProvider = LibraryEntriesApiProvider();
  final loginApiProvider = LoginApiProvider();
  final animesApiProvider = AnimesApiProvider();
  final postApiProvider = PostApiProvider();
  final streamingLinkApiProvider = StreamingLinkApiProvider();
  final groupsApiProvider = GroupsApiProvider();

  Future<List<Category>> fetchCategoriesByAnimeId(String animeId) => categoryApiProvider.fetchCategoriesByAnimeId(animeId);

  ///User
  Future<String> addFollow(String followedUserId) async => userInfoApiProvider.addFollow(followedUserId);
  void deleteFollow(String followId) async => userInfoApiProvider.deleteFollow(followId);

  ///fetch the user information by id
  Future<User> fetchUserInfoByLink(String link) => userInfoApiProvider.fetchUserInfoByLink(link);
  Future<User> fetchUserInfoById(String userId) => userInfoApiProvider.fetchUserInfoById(userId);

  Future<String> fetchLoggedInUserId() => userInfoApiProvider.fetchLoggedInUserId();

  Future<User> fetchLoggedInUserInfo() => userInfoApiProvider.fetchLoggedInUserInfo();

  Future<LibraryEntriesData> fetchLibraryEntriesData(String id) => libraryEntriesApiProvider.fetchLibraryEntriesData(id);
  Stream<List<LibraryEntry>> fetchLibraryEntries(String id) => libraryEntriesApiProvider.fetchLibraryEntries(id);

  ///Anime
  Future<List<Anime>> fetchTrendingAnimes() => animesApiProvider.fetchTrendingAnimes();

  Future<List<Anime>> fetchLoggedInUserAnimes(List<LibraryEntry> libraryEntries) => animesApiProvider.fetchAnimesFromLibraryEntries(libraryEntries);

  Future<Anime> fetchBreifAnimeFromLibraryEntry(LibraryEntry libraryEntry) => animesApiProvider.fetchBriefAnimeFromLibraryEntry(libraryEntry);

  Future<List<Anime>> fetchAnimes(String link, {bool withOnlyPosterImage = false, int offset = 0}) =>
      animesApiProvider.fetchAnimes(link, withOnlyPosterImage: withOnlyPosterImage, offset: offset);

  Future<List<Anime>> fetchAnimesByCatrgoryId(String categoryId, {bool withOnlyPosterImage = false, int offset = 0}) =>
      animesApiProvider.fetchAnimesByCatrgoryId(categoryId, withOnlyPosterImage: withOnlyPosterImage, offset: offset);

  Future<List<Anime>> fetchAnimesByStreamerId(String streamerId, {int offset = 0}) =>
      animesApiProvider.fetchAnimesByStreamerId(streamerId, offset: offset);

  Future<Anime> fetchAnimeById(String animeId) => animesApiProvider.fetchAnimeById(animeId);

  ///Episode
  Future<List<Episode>> fetchEpisodesByAnimeId(String animeId, {int offset = 0}) async =>
      animesApiProvider.fetchEpisodesByAnimeId(animeId, offset: offset);

  ///LibraryEntries
  @Deprecated("avoid using this, messy as hell")
  Future<Map<LibraryEntry, Anime>> fetchLibraryEntryToAnimeMap(List<LibraryEntry> libraryEntries) =>
      animesApiProvider.fetchLibraryEntryToAnimeMap(libraryEntries);

  Future<LibraryEntriesData> fetchLibraryEntriesDataByAnimeId(String userId, String animeId) => libraryEntriesApiProvider.fetchLibraryEntriesDataByAnimeId(userId, animeId);

  Future addLibraryEntry(String animeId, Status status) => libraryEntriesApiProvider.addLibraryEntry(animeId, status);

  Future<bool> handleLogin(String username, String password) => loginApiProvider.handleLogin(username, password);

  ///POST
  Future<List<Post>> fetchPosts({int offset = 0}) async => postApiProvider.fetchPosts(offset: offset);

  Stream<Post> fetchPost({int offset = 0}) => postApiProvider.fetchPost(offset: offset);

  Stream<Post> fetchPostsByAnimeId(String animeId, {int offset = 0}) => postApiProvider.fetchPostsByAnimeId(animeId, offset: offset);

  Stream<Post> fetchFeedPost({int offset = 0}) => postApiProvider.fetchFeedPost(offset: offset);

  ///COMMENT
  Stream<Comment> fetchComments(String postId, {int offset = 0}) => postApiProvider.fetchComments(postId, offset: offset);

  Future<Comment> uploadComment(String postId, String content) async => postApiProvider.uploadComment(postId, content);

  ///StreamingLinks
  Future<List<StreamingLink>> fetchStreamingLinksByAnimeId(String animeId) => streamingLinkApiProvider.fetchStreamingLinksByAnimeId(animeId);

  ///Groups
  Stream<GroupMember> fetchGroupMembers(String userId) => groupsApiProvider.fetchGroupMembers(userId);
}
