import 'package:animey/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:animey/models/library_entries.dart';
import 'anime_bloc.dart';
import 'user_bloc.dart';

class LibraryEntriesBloc{
  final _repository = Repository();
  final _libraryEntriesDataFetcher = BehaviorSubject<LibraryEntriesData>();
  final _libraryEntriesFetcher = BehaviorSubject<List<LibraryEntry>>();
  bool _initialized = false;
  List<LibraryEntry> _entries = List<LibraryEntry>();


  Observable<LibraryEntriesData> get libraryEntriesData => _libraryEntriesDataFetcher.stream;
  Observable<List<LibraryEntry>> get libraryEntries =>_libraryEntriesFetcher.stream;

  fetchLibraryEntriesData({String userId}) async{
    if(userId== null){
      if(userBloc.userId != null){
        LibraryEntriesData data = await _repository.fetchLibraryEntriesData(userBloc.userId);
        //_libraryEntriesDataFetcher.stream.drain();
        //animeBloc.fetchLibraryEntryToAnimeMap(data.data);
        _libraryEntriesDataFetcher.sink.add(data);
      }
    }else{
      LibraryEntriesData data = await _repository.fetchLibraryEntriesData(userId);
      _libraryEntriesDataFetcher.sink.add(data);
    }
  }

  fetchLibraryEntries({String userId}) async{
    if(userId== null){
      if(userBloc.userId != null){
        _repository.fetchLibraryEntries(userBloc.userId).listen((entries){///FIXME: avoid using userBloc
          _entries.addAll(entries);
          _libraryEntriesFetcher.sink.add(_entries);
        });
      }
    }else{
      _repository.fetchLibraryEntries(userId).listen((entries){
        _entries.addAll(entries);
        _libraryEntriesFetcher.sink.add(_entries);
      });
    }
  }

  void fetchLibraryEntriesDataByAnimeId(String userId, String animeId) async {
    LibraryEntriesData data = await _repository.fetchLibraryEntriesDataByAnimeId(userId, animeId);
    if(!_libraryEntriesDataFetcher.isClosed) _libraryEntriesDataFetcher.sink.add(data);
  }

  initializeLibraryEntriesData() async{
    if(userBloc.userId != null && !_initialized){
      LibraryEntriesData data = await _repository.fetchLibraryEntriesData(userBloc.userId).whenComplete(()=>_initialized = true);
      _libraryEntriesDataFetcher.stream.drain();
      animeBloc.fetchLibraryEntryToAnimeMap(data.data);
      _libraryEntriesDataFetcher.sink.add(data);
    }
  }

  removeLibraryEntry(String entryId) async{

  }

  addLibraryEntry(String animeId, Status status)async{
    _repository.addLibraryEntry(animeId, status).whenComplete(()=>fetchLibraryEntriesData());
  }

  dispose(){
    _libraryEntriesDataFetcher.close();
    _libraryEntriesFetcher.close();
  }
}

final libraryEntriesBloc = LibraryEntriesBloc();