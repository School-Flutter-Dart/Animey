import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animey/blocs/posts_page_bloc.dart';
import 'package:animey/models/post.dart' as PostModel;
import 'package:animey/ui/post_page/post_card.dart';
import 'package:animey/blocs/login_bloc_provider.dart';
import 'package:animey/blocs/user_bloc.dart';
import 'package:animey/resources/string_values.dart';
import 'package:animey/models/user.dart';

enum PostCategory { GLOBAL, FEED }

class PostsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<PostCategory, bool> selected = Map<PostCategory, bool>();

  //PostCategory postCategory = PostCategory.GLOBAL;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.redAccent,
          appBar: AppBar(
            title: TabBar(tabs: [
              Tab(text: 'Global'),
              Tab(text: 'Feed'),
            ]),
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            //showLogInDialog();
                          },
                          child: StreamBuilder(
                            stream: userBloc.loggedInUserInfo,
                            builder: (_, AsyncSnapshot<User> asyncSnapshot) {
                              if (asyncSnapshot.hasData) {
                                var user = asyncSnapshot.data;
                                return ClipOval(
                                    child: Image.network(
                                  user.attributes.avatar == null ? NullAvatarUrl : user.attributes.avatar.medium,
                                  fit: BoxFit.cover,
                                  width: 90.0,
                                  height: 90.0,
                                ));
                              } else if (asyncSnapshot.hasError)
                                return Center(child: Text(asyncSnapshot.error));
                              else
                                return Center(
                                    child: ClipOval(
                                        child: Container(
                                  color: Colors.black,
                                  width: 90.0,
                                  height: 90.0,
                                )));
                            },
                          ))),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  title: Text('Groups'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Donate'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('About'),
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                        context: context,
                        applicationName: 'Animey',
                        applicationIcon: Image.asset(
                          'assets/ic_launcher.png',
                          scale: 2,
                        ),
                        applicationVersion: '0.0.9+2 alpha',
                        children: [
                          Text(
                              'Animey is an Android client for Kitsu.io that barely works currently, but I am trying my best to implement all the features necessary.')
                        ]);
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            PostsListView(postCategory: PostCategory.GLOBAL),
            StreamBuilder(
              stream: LoginBlocProvider.of(context).loginStatusBool,
              builder: (_, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data)
                    return PostsListView(postCategory: PostCategory.FEED);
                  else
                    return Center(
                      child: Text('NOT SIGNED IN'),
                    );
                } else {
                  return Container();
                }
              },
            )
          ]),
        ));
  }
}

class PostsListView extends StatefulWidget {
  final PostCategory postCategory;

  PostsListView({@required this.postCategory});

  @override
  State<StatefulWidget> createState() => PostsListViewState();
}

class PostsListViewState extends State<PostsListView> {
  final PostsPageBloc bloc = PostsPageBloc();
  final scrollController = ScrollController();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        switch (widget.postCategory) {
          case PostCategory.GLOBAL:
            bloc.fetchPosts();
            break;
          case PostCategory.FEED:
            bloc.fetchFeedPosts();
            break;
        }
      }
    });
    Timer(Duration(seconds: 2), () {
      if (this.mounted) refreshIndicatorKey.currentState.show();
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () {
          bloc.resetPostsFetcher();
          switch (widget.postCategory) {
            case PostCategory.GLOBAL:
              return bloc.fetchPosts();
            case PostCategory.FEED:
              return bloc.fetchFeedPosts();
            default:
              throw Exception('Umatched case');
          }
        },
        child: StreamBuilder(
          stream: bloc.posts,
          builder: (_, AsyncSnapshot<List<PostModel.Post>> asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              var posts = asyncSnapshot.data;
              return ListView(
                controller: scrollController,
                children: buildChildren(posts),
              );
            } else if (asyncSnapshot.hasError) {
              return Center(
                  child: Column(
                children: <Widget>[
                  Text(
                    asyncSnapshot.error,
                    style: TextStyle(color: Colors.white),
                  ),
                  RaisedButton(
                    child: Text('Refresh'),
                    onPressed: () {
                      setState(() {
                        bloc.resetPostsFetcher();
                        switch (widget.postCategory) {
                          case PostCategory.GLOBAL:
                            bloc.fetchPosts();
                            break;
                          case PostCategory.FEED:
                            bloc.fetchFeedPosts();
                            break;
                          default:
                            throw Exception('Umatched case');
                        }
                      });
                    },
                  )
                ],
              ));
            } else {
              //return Center(child: CircularProgressIndicator());
              return Container();
            }
          },
        ));
  }

  List<Widget> buildChildren(List<PostModel.Post> posts) {
    var children = List<Widget>();
    children.addAll(posts.map((post) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Hero(
            tag: post.id,
            child: PostCard(
              post: post,
              keepPadding: true,
            ),
          ));
    }));
    children.add(LinearProgressIndicator());
    return children;
  }
}
