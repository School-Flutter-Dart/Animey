import 'package:animey/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:animey/models/user.dart';

class UserBloc {
  final _repository = Repository();
  final _userInfoFetcher = BehaviorSubject<User>();
  final _loggedInUserInfoFetcher = BehaviorSubject<User>();
  final _loggedInUserId = BehaviorSubject<String>();
  User user;
  String userId;

  Observable<User> get userInfo => _userInfoFetcher.stream;
  Observable<User> get loggedInUserInfo => _loggedInUserInfoFetcher.stream;
  Observable<String> get loggedInUserId => _loggedInUserId.stream;

  void addFollow() async {
    //var user = await _userInfoFetcher.stream.last.wrapped;
    print("the userId is ${user.id}");
    String followId = await _repository.addFollow(user.id);
    user.isFollowed = true;
    user.followId = followId;
    if (!_userInfoFetcher.isClosed) {
      _userInfoFetcher.sink.add(user);
    }
  }

  void deleteFollow() async {
//    var user = await _userInfoFetcher.stream.last.wrapped.then((user){
//      user.isFollowed = false;
//      user.followId = "";
//      if(!_userInfoFetcher.isClosed) _userInfoFetcher.sink.add(user);
//    });
    user.isFollowed = false;
    user.followId = "";
    _repository.deleteFollow(user.followId);
  }

  fetchUserInfoByLink(String link) async {
    User user = await _repository.fetchUserInfoByLink(link);
    if (!_userInfoFetcher.isClosed) {
      _userInfoFetcher.sink.add(user);
    }
  }

  fetchUserInfoById(String userId) async {
    user = await _repository.fetchUserInfoById(userId);
    if (!_userInfoFetcher.isClosed) _userInfoFetcher.sink.add(user);
  }

  fetchLoggedInUserId() async {
    String id = await _repository.fetchLoggedInUserId();
    userId = id;
    _loggedInUserId.sink.add(id);
  }

  fetchLoggedInUserInfo() async {
    User user = await _repository.fetchLoggedInUserInfo();
    if (!_userInfoFetcher.isClosed) {
      _userInfoFetcher.sink.add(user);
    }
    _loggedInUserInfoFetcher.sink.add(user);
  }

  removeLoggedInUserInfo() async {
    _loggedInUserInfoFetcher.drain();
  }

  removeLoggedInUserId() async {
    _loggedInUserId.drain();
  }

  dispose() {
    _userInfoFetcher.close();
    _loggedInUserId.close();
    _loggedInUserInfoFetcher.close();
  }
}

final userBloc = UserBloc();
