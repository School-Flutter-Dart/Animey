import 'package:rxdart/rxdart.dart';
import 'package:animey/models/streaming_link.dart';
import 'package:animey/resources/repository.dart';

class StreamingLinkBloc{
  final _repository = Repository();
  final _streamingLinksFetcher = BehaviorSubject<List<StreamingLink>>();

  Observable<List<StreamingLink>> get streamingLinks => _streamingLinksFetcher.stream;

  void fetchStreamingLinksByAnimeId(String animeId)async{
    var streamingLinks = await _repository.fetchStreamingLinksByAnimeId(animeId);
    _streamingLinksFetcher.sink.add(streamingLinks);
  }

  dispose(){
    _streamingLinksFetcher.close();
  }
}