import 'package:animey/models/comment.dart';
import 'package:animey/models/post.dart';
import 'package:animey/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PostsPageBloc {
  final _repository = Repository();
  final _postsFetcher = BehaviorSubject<List<Post>>();
  final _commentsFetcher = BehaviorSubject<List<Comment>>();
  List<Post> _posts = List<Post>();
  List<Comment> _comments = List<Comment>();
  int _postsOffset = 0;
  int _commentsOffset = 0;

  Observable<List<Post>> get posts => _postsFetcher.stream;
  Observable<List<Comment>> get comments => _commentsFetcher.stream;

  Future fetchPosts() async {
    _repository.fetchPost(offset: _postsOffset).listen((post){
      if(post == null){//the fetching failed

      }

      if(!_postsFetcher.isClosed&&(_posts.isEmpty || _posts.where((p)=>p.id == post.id).isEmpty)){
        _posts.add(post);
        _postsFetcher.sink.add(_posts);
      }
    },onError: (error){
      print("ONERROR REACHED!!!");
      _postsFetcher.sink.addError('Something went wrong ヾ(°д°)ノ゛');
    });
    _postsOffset+=10;
    return Future.delayed(Duration(seconds: 3));
  }

  Future<void> fetchFeedPosts() async{
    _repository.fetchFeedPost(offset: _postsOffset).listen((post){
      if(!_postsFetcher.isClosed&&(_posts.isEmpty || _posts.where((p)=>p.id == post.id).isEmpty)){
        _posts.add(post);
        _postsFetcher.sink.add(_posts);
      }
    });
    _postsOffset+=10;
  }

  void uploadComment(String postId, String content)async{
    var comment = await _repository.uploadComment(postId, content);
    if(comment != null){
      _comments.add(comment);
      _commentsFetcher.sink.add(_comments);
    }
  }

  void fetchComments(String postId) async {
    _repository.fetchComments(postId, offset: _commentsOffset).listen((comment){
      _comments.add(comment);
      _commentsFetcher.sink.add(_comments);
    });
//    var comments = await _repository.fetchComments(postId, offset: _commentsOffset);
//    _comments.addAll(comments);
//    _commentsFetcher.sink.add(_comments);
    _commentsOffset+=10;
  }

  void resetCommentsFetcher(){
    _commentsOffset= 0;
    _comments.clear();
    _commentsFetcher.drain();
  }

  Future<void> resetPostsFetcher() async {
    _postsOffset = 0;
    _posts.clear();
    _postsFetcher.drain();
  }

  dispose() {
    _commentsFetcher.close();
    _postsFetcher.close();
  }
}
