import 'package:animey/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:animey/models/anime.dart';
import 'package:animey/models/category.dart';
import 'package:animey/models/episode.dart';
import 'package:animey/models/library_entries.dart';
import 'package:animey/models/streaming_link.dart';

enum Source {StreamerId, Link, CategoryId}
class AnimeBloc{
  final _repository = Repository();
  final _trendingAnimesFetcher = BehaviorSubject<List<Anime>>();
  final _loggedInUsereAnimesFetcher = BehaviorSubject<List<Anime>>();
  final _animeFetcher = BehaviorSubject<Anime>();
  final _libEntryToAnimeFetcher = BehaviorSubject<Map<LibraryEntry, Anime>>();
  final _animesFetcher = BehaviorSubject<List<Anime>>();
  final _episodesFetcher = BehaviorSubject<List<Episode>>();
  final _categoriesFetcher = BehaviorSubject<List<Category>>();
  final _streamingLinksFetcher = BehaviorSubject<List<StreamingLink>>();

  Source _source;
  //String _id = "1";
  String _sourceStr = "";
  int _offset = 0;
  int _episodeOffset = 0;
  List<Anime> _animes = List<Anime>();
  List<Episode> _episodes = List<Episode>();

  //set id(id) => _id = id;
  Observable<List<Category>> get categories => _categoriesFetcher.stream;
  Observable<List<Anime>> get treandingAnimes => _trendingAnimesFetcher.stream;
  Observable<List<Anime>> get loggedInUserAnimes => _loggedInUsereAnimesFetcher.stream;
  Observable<Anime> get anime => _animeFetcher.stream;
  Observable<Map<LibraryEntry,Anime>> get libEntryToAnimeMap => _libEntryToAnimeFetcher.stream;
  Observable<List<Anime>> get animes => _animesFetcher.stream;
  Observable<List<Episode>> get episodes => _episodesFetcher.stream;
  Observable<List<StreamingLink>> get streamingLinks => _streamingLinksFetcher.stream;

  void fetchStreamingLinksByAnimeId(String animeId)async{
    var streamingLinks = await _repository.fetchStreamingLinksByAnimeId(animeId);
    if(!_streamingLinksFetcher.isClosed)_streamingLinksFetcher.sink.add(streamingLinks);
  }

  fetchAnimes(String link,{bool withOnlyPosterImage = false}) async{
    List<Anime> animes = await _repository.fetchAnimes(link,withOnlyPosterImage: withOnlyPosterImage, offset: _offset);
    if(!_animesFetcher.isClosed){
      _animes.addAll(animes);
      _animesFetcher.sink.add(_animes);
      _source = Source.Link;
      _sourceStr = link;
      _offset+=10;
    }
  }

//  fetchMoreAnimes(String link,{bool withOnlyPosterImage = false}) async{
//    _offset+=10;
//    List<Anime> animes = await _repository.fetchAnimes(link,withOnlyPosterImage: withOnlyPosterImage, offset: _offset);
//    _animes.addAll(animes);
//    _animesFetcher.sink.add(_animes);
//  }

  void fetchMoreAnimes(){
    switch(_source){
      case Source.Link: fetchAnimes(_sourceStr, withOnlyPosterImage: false); break;
      case Source.CategoryId: fetchAnimesByCategoryId(_sourceStr, withOnlyPosterImage: true); break;
      case Source.StreamerId: fetchAnimesByStreamerId(_sourceStr); break;
      default: throw Exception('failed to select source');
    }
  }

  void resetAnimes(){
    _offset = 0;
    _animes.clear();
    _animesFetcher.drain();
  }

  void fetchAnimesByCategoryId(String categoryId, {bool withOnlyPosterImage = false}) async {
    List<Anime> animes = await _repository.fetchAnimesByCatrgoryId(categoryId,withOnlyPosterImage: withOnlyPosterImage, offset: _offset);
    if(!_animesFetcher.isClosed) {
      _animes.addAll(animes);
      _animesFetcher.sink.add(_animes);
      _source = Source.CategoryId;
      _sourceStr = categoryId;
      _offset += 10;
    }
  }

//  fetchMoreAnimesByCategoryId(String categoryId, {bool withOnlyPosterImage}) async {
//    _offset += 10;
//    List<Anime> animes = await _repository.fetchAnimesByCatrgoryId(categoryId,withOnlyPosterImage: withOnlyPosterImage,offset: _offset);
//    _animes.addAll(animes);
//    _animesFetcher.sink.add(_animes);
//  }

  fetchAnimesByStreamerId(String streamerId) async {
    var animes = await _repository.fetchAnimesByStreamerId(streamerId, offset: _offset);
    _animes.addAll(animes);
    _animesFetcher.sink.add(_animes);
    _source = Source.StreamerId;
    _sourceStr = streamerId;
    _offset+=10;
  }

  fetchTrendingAnimes() async{
    List<Anime> trendingAnimes = await _repository.fetchTrendingAnimes();
    if(!_trendingAnimesFetcher.isClosed)_trendingAnimesFetcher.sink.add(trendingAnimes);
  }

  fetchLoggedInUserAnimes(List<LibraryEntry> libraryEntries) async{
    List<Anime> animes = await _repository.fetchLoggedInUserAnimes(libraryEntries);
    if(!_loggedInUsereAnimesFetcher.isClosed)_loggedInUsereAnimesFetcher.add(animes);
  }

  fetchAnimeById(String animeId) async{
    Anime anime = await _repository.fetchAnimeById(animeId);
    if(!_animeFetcher.isClosed) _animeFetcher.add(anime);
  }

  fetchBriefAnime(LibraryEntry libraryEntry) async{
    Anime anime = await _repository.fetchBreifAnimeFromLibraryEntry(libraryEntry);
    if(!_animeFetcher.isClosed) _animeFetcher.add(anime);
  }

  fetchEpisodesByAnimeId(String animeId) async{
    var episodes = await _repository.fetchEpisodesByAnimeId(animeId,offset: _episodeOffset);
    if(!_episodesFetcher.isClosed){
      _episodes.addAll(episodes);
      _episodesFetcher.sink.add(_episodes);
      _episodeOffset+=10;
    }
  }

  void resetEpisodesFetcher(){
    _episodeOffset = 0;
    _episodes.clear();
    _episodesFetcher.drain();
  }

  fetchCategoriesByAnimeId(String animeId) async{
    List<Category> categories = await _repository.fetchCategoriesByAnimeId(animeId);
    if(!_categoriesFetcher.isClosed) _categoriesFetcher.sink.add(categories);
  }

  @Deprecated('AnimeBloc should not have side effect, user only LibraryEntry')
  fetchLibraryEntryToAnimeMap(List<LibraryEntry> libraryEntries) async{
    _libEntryToAnimeFetcher.drain();
    Map<LibraryEntry, Anime> map = await _repository.fetchLibraryEntryToAnimeMap(libraryEntries);
    _libEntryToAnimeFetcher.sink.add(map);
  }

  dispose(){
    _loggedInUsereAnimesFetcher.close();
    _libEntryToAnimeFetcher.close();
    _trendingAnimesFetcher.close();
    _animeFetcher.close();
    _animesFetcher.close();
    _episodesFetcher.close();
    _categoriesFetcher.close();
    _streamingLinksFetcher.close();
  }
}

final animeBloc = AnimeBloc();