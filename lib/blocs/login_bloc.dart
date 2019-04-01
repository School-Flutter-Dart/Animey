import 'package:animey/resources/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animey/resources/string_values.dart';
import 'user_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:animey/models/user.dart';

enum LoginStatus {LOGGED_IN, LOGGING_IN, NOT_LOGGED_IN}

class LoginBloc {
  final _repository = Repository();
  final _loginStatusBoolFetcher = BehaviorSubject<bool>();
  final _loginStatusFetcher = BehaviorSubject<LoginStatus>();
  final _userInfoFetcher = BehaviorSubject<User>();
  final _userIdFetcher = BehaviorSubject<String>();
  bool isAuthed = false;
  String accessToken;
  String authedUserId;

  Observable<bool> get loginStatusBool => _loginStatusBoolFetcher.stream;
  Observable<LoginStatus> get loginStatus => _loginStatusFetcher.stream;
  Observable<User> get loggedUserInfo =>_userInfoFetcher.stream;
  Observable<String> get userId =>_userIdFetcher.stream;

  Future<bool> handleLogin([String username, String password]) async {
    _loginStatusFetcher.sink.add(LoginStatus.LOGGING_IN);
    var sharedPreferences = await SharedPreferences.getInstance();
    if (username == null) {
      // try to check if user has logged in before
      if (sharedPreferences.getString(AccessToken) != null) {
        isAuthed = true;
        username = sharedPreferences.getString(Username);
        password = sharedPreferences.getString(Password);
        _userIdFetcher.sink.add(await _repository.fetchLoggedInUserId());
      }else{
        print("hi there before _login status fetcher");
        _loginStatusBoolFetcher.sink.add(false);
        _loginStatusFetcher.sink.add(LoginStatus.NOT_LOGGED_IN);
        return false;
      }
    }
    bool wasSuccessful = await _repository.handleLogin(username, password);

    if (wasSuccessful) {
      accessToken = sharedPreferences.getString(AccessToken);
      authedUserId = sharedPreferences.getString(UserId);
      //userBloc.fetchLoggedInUserId();
      String id = await _repository.fetchLoggedInUserId();
      sharedPreferences.setString(UserId, id);
      userBloc.fetchLoggedInUserInfo();
      _loginStatusBoolFetcher.sink.add(true);
      _loginStatusFetcher.sink.add(LoginStatus.LOGGED_IN);
      _userIdFetcher.sink.add(await _repository.fetchLoggedInUserId());
      isAuthed = true;
      return true;
    }else{
      _loginStatusBoolFetcher.sink.add(false);
      _loginStatusFetcher.sink.add(LoginStatus.NOT_LOGGED_IN);
      return false;
    }
  }

  void handleSignout() async {
    _loginStatusFetcher.sink.add(LoginStatus.NOT_LOGGED_IN);
    _loginStatusBoolFetcher.sink.add(false);

    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(AccessToken);
    sharedPreferences.remove(TokenType);
    sharedPreferences.remove(ExpiresIn);
    sharedPreferences.remove(RefreshToken);
    sharedPreferences.remove(Scope);
    sharedPreferences.remove(CreatedAt);
    sharedPreferences.remove(Username);
    sharedPreferences.remove(Password);

    userBloc.removeLoggedInUserId();
    userBloc.removeLoggedInUserInfo();
  }

  void fetchUserInfo()async{
    var user = await _repository.fetchLoggedInUserInfo();
    _userInfoFetcher.sink.add(user);
  }

  dispose(){
    _loginStatusBoolFetcher.close();
    _loginStatusFetcher.close();
    _userInfoFetcher.close();
    _userIdFetcher.close();
  }
}

//final loginBloc = LoginBloc();
