import 'package:flutter/material.dart';
import 'login_bloc.dart';

class LoginBlocProvider extends InheritedWidget {
  final LoginBloc loginBloc;

  LoginBlocProvider({Key key, Widget child})
      : loginBloc = LoginBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LoginBlocProvider)
            as LoginBlocProvider)
        .loginBloc;
  }
}
