import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:animey/models/anime.dart';
import 'models/library_entries.dart';
import 'models/user.dart';
import 'utils/model_utils.dart';
import 'blocs/anime_bloc.dart';
import 'blocs/anime_bloc_provider.dart';
import 'blocs/user_bloc.dart';
import 'blocs/login_bloc.dart';
import 'blocs/login_bloc_provider.dart';
import 'ui/posts_page.dart';
import 'ui/library_page.dart';
import 'ui/library_entry_page.dart';

import 'ui/my_library_entry_page.dart';

bool loaded = false;

void main() {
//  var url = "https://kitsu.io/api/oauth/token";
//  var client = new http.Client();
//  var request = new http.Request('POST', Uri.parse(url));
//  request.bodyFields = {
//    'grant_type': 'password',
//    'username': 'georgefung78@live.com',
//    'password': 'fjq110388',
//    //'client_id':'dd031b32d2f56c990b1425efe6c42ad847e7fe3ab46bf1299f05ecd856bdb7dd',
//    //'CLIENT_SECRET': '54d7307928f63414defd96399fc31ba847961ceaecef3a5fd93144e960c0e151'
//  };
//  //request.body = "grant_type=password&username=livinglist&password=mypassword&client_id=dd031b32d2f56c990b1425efe6c42ad847e7fe3ab46bf1299f05ecd856bdb7dd',";
//  var future = client
//      .send(request)
//      .then((response){
//        print(response.statusCode);
//        return response.stream
//          .bytesToString()
//          .then((value) => print(value.toString()));})
//      .catchError((error) => print(error.toString()));

  runApp(MyApp());
}

const defaultTextStyle = TextStyle(color: Colors.black);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider(
        child: MaterialApp(
      title: 'Animey',
      theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: Colors.redAccent,
          primarySwatch: Colors.red,
          buttonColor: Colors.red,
          primaryTextTheme: TextTheme(
            body1: TextStyle(color: Colors.white),
          )),
      home: MainPage(),
      //home: HomePage(title: 'Animey'),
    ));
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selected = 0;
  final usernameTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      LoginBlocProvider.of(context).handleLogin();
      initialized = true;
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _selected == 0 ? Colors.red : Colors.grey[600],
              ),
              title: Text(
                'Home',
                style: TextStyle(color: _selected == 0 ? Colors.red : Colors.grey[600]),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books, color: _selected == 1 ? Colors.red : Colors.grey[600]),
              title: Text(
                'Library',
                style: TextStyle(color: _selected == 1 ? Colors.red : Colors.grey[600]),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_contact_calendar, color: _selected == 2 ? Colors.red : Colors.grey[600]),
              title: Text(
                'My Library',
                style: TextStyle(color: _selected == 2 ? Colors.red : Colors.grey[600]),
              )),
        ],
        onTap: (selected) {
          if (selected != _selected) {
            setState(() {
              _selected = selected;
            });
          }
        },
      ),
      body: buildMainPage(),
    );
  }

  Widget buildMainPage() {
    switch (_selected) {
      case 0:
        return PostsPage();
      case 1:
        return LibraryPage();
      case 2:
        return buildMyLibraryPage();
      default:
        throw Exception();
    }
  }

  Widget buildMyLibraryPage() {
    return StreamBuilder(
      stream: LoginBlocProvider.of(context).loginStatusBool,
      builder: (_, AsyncSnapshot<bool> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          if (asyncSnapshot.data) {
            return StreamBuilder(
              stream: LoginBlocProvider.of(context).userId,
              builder: (_, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String userId = snapshot.data;
                  return MyLibraryEntryPgae(userId: userId);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return Center(
              child: RaisedButton(child: Text('Log in to enjoy'), onPressed: () => showLogInDialog()),
            );
          }
        } else if (asyncSnapshot.hasError) {
          return Text(asyncSnapshot.error);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  showLogInDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                color: Theme.of(context).primaryColor,
              ),
              width: 300,
              height: 300,
              child: Center(
                  child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      child: StreamBuilder(
                        stream: LoginBlocProvider.of(context).loginStatus,
                        builder: (_, AsyncSnapshot<LoginStatus> asyncSnapshot) {
                          if (asyncSnapshot.hasData) {
                            if (asyncSnapshot.data == LoginStatus.LOGGED_IN) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 12,
                                    ),
                                    RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      child: Text('SIGN OUT'),
                                      onPressed: () {
                                        LoginBlocProvider.of(context).handleSignout();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else if (asyncSnapshot.data == LoginStatus.LOGGING_IN) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text('SIGNING IN...'),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: TextFormField(
                                      controller: usernameTextEditingController,
                                      decoration: InputDecoration(labelText: 'Username'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: TextFormField(
                                      controller: passwordTextEditingController,
                                      decoration: InputDecoration(labelText: 'Password'),
                                      obscureText: true,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  RaisedButton(
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      LoginBlocProvider.of(context)
                                          .handleLogin(usernameTextEditingController.text, passwordTextEditingController.text);
                                    },
                                  ),
                                ],
                              );
                            }
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ))),
            ),
          );
        });
  }
}

//class HomePage extends StatefulWidget {
//  HomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
//  final appbarKey = GlobalKey();
//  final usernameTextEditingController = TextEditingController();
//  final passwordTextEditingController = TextEditingController();
//
//  bool isLoggedin = false;
//  bool initialized = false;
//
//  @override
//  bool get wantKeepAlive => true;
//
//  @override
//  void initState() {
//    super.initState();
//    animeBloc.fetchTrendingAnimes();
//    //userBloc.fetchLoggedInUserId();
//  }
//
//  @override
//  void dispose() {
//    //libraryEntriesBloc.dispose();
//    //animeBloc.dispose();
//    //LoginBlocProvider.of(context).dispose();
//    //userBloc.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (!initialized) {
//      LoginBlocProvider.of(context).handleLogin();
//      initialized = true;
//    }
//    return DefaultTabController(
//      length: 3,
//      child: Scaffold(
//
//        backgroundColor: Colors.white,
//        appBar: AppBar(
//          key: appbarKey,
//          title: Text("Animey"),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.search),
//              onPressed: () {
//                showSearch(context: context, delegate: AnimeSearch());
//              },
//            )
//          ],
//          bottom: TabBar(tabs: [
//            Tab(
//              icon: Icon(Icons.show_chart),
//              text: "Post",
//            ),
//            Tab(
//              icon: Icon(Icons.library_books),
//              text: "Library",
//            ),
//            Tab(
//              icon: Icon(Icons.bookmark_border),
//              text: "My Library",
//            ),
//          ]),
//        ),
//        body: TabBarView(children: [PostsPage(), LibraryPage(), buildMyLibraryPage()]),
//      ),
//    );
//  }
//}
