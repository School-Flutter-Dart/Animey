import 'package:animey/models/comment.dart';
import 'package:animey/models/post.dart';
import 'package:animey/models/user.dart';
import 'package:animey/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PostItem {
  Post post;
  User user;
}

class PostBloc {
  final _repository = Repository();
  final _postsFetcher = BehaviorSubject<List<Post>>();
  final _commentsFetcher = BehaviorSubject<List<Comment>>();
  List<Post> _posts = List<Post>();
  List<Comment> _comments = List<Comment>();
  int _postsOffset = 0;
  int _commentsOffset = 0;

  Observable<List<Post>> get posts => _postsFetcher.stream;
  Observable<List<Comment>> get comments => _commentsFetcher.stream;

  Future<void> fetchPosts() async {
    _repository.fetchPost(offset: _postsOffset).listen((post) {
      if ((!_postsFetcher.isClosed) && (_posts.isEmpty || _posts.where((p) => p.id == post.id).isEmpty)) {
        _posts.add(post);
        _postsFetcher.sink.add(_posts);
      }
    });
    _postsOffset += 10;
  }

  void fetchPostsByAnimeId(String animeId){
    _repository.fetchPostsByAnimeId(animeId,offset: _postsOffset).listen((post) {
      if ((!_postsFetcher.isClosed) && (_posts.isEmpty || _posts.where((p) => p.id == post.id).isEmpty)) {
        _posts.add(post);
        _postsFetcher.sink.add(_posts);
      }
    });
    _postsOffset += 10;
  }

  void uploadComment(String postId, String content) async {
    var comment = await _repository.uploadComment(postId, content);
    if (comment != null) {
      _comments.add(comment);
      _commentsFetcher.sink.add(_comments);
    }
  }

  void fetchComments(String postId) async {
    _repository.fetchComments(postId, offset: _commentsOffset).listen((comment) {
      if (comment == null && _comments.isEmpty) {
        _commentsFetcher.sink.add([]); //no comments, add a empty list
      } else if (!_commentsFetcher.isClosed) {
        _comments.add(comment);
        _commentsFetcher.sink.add(_comments);
      }
    });
    _commentsOffset += 10;
  }

  void resetCommentsFetcher() {
    _commentsOffset = 0;
    _comments.clear();
    _commentsFetcher.drain();
  }

  Future<void> resetPostsFetcher() async {
    _postsOffset = 0;
    _posts.clear();
    _postsFetcher.drain();
//    var posts = await _repository.fetchPosts(offset: _postsOffset).whenComplete(() {
//      return;
//    });
//    _posts.addAll(posts);
//    _postsFetcher.sink.add(_posts);
  }

  dispose() {
    _commentsFetcher.close();
    _postsFetcher.close();
  }
}
