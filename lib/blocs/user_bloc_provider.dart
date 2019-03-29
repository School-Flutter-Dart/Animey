import 'package:flutter/material.dart';
import 'user_bloc.dart';

class UserBlocProvider extends InheritedWidget {
  final UserBloc userBloc;

  UserBlocProvider({Key key, Widget child, String link})
      : userBloc = UserBloc(),
        super(key: key, child: child){
    userBloc.fetchUserInfoByLink(link);
  }

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static UserBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UserBlocProvider) as UserBlocProvider).userBloc;
  }
}
