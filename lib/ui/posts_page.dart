import 'package:flutter/material.dart';
import 'package:animey/blocs/posts_page_bloc.dart';
import 'package:animey/models/post.dart';
import 'package:animey/ui/post_page/post_card.dart';
import 'package:animey/blocs/login_bloc_provider.dart';

enum PostCategory { GLOBAL, FEED }

class PostsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final bloc = PostsPageBloc();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final Map<PostCategory, bool> selected = Map<PostCategory, bool>();
  bool isLoggedIn = false;
  PostCategory postCategory = PostCategory.GLOBAL;

  @override
  void initState() {
    super.initState();

    selected[PostCategory.GLOBAL] = true;
    selected[PostCategory.FEED] = false;

    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        switch (postCategory) {
          case PostCategory.GLOBAL:
            bloc.fetchPosts(); break;
          case PostCategory.FEED:
            bloc.fetchFeedPosts(); break;
          default:
            throw Exception('Umatched case');
        }
      }
    });
    bloc.fetchPosts();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isLoggedIn = LoginBlocProvider.of(context).isAuthed;
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.redAccent,
        body: Column(
          children: <Widget>[
            Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  ChoiceChip(
                    label: Text('Global'),
                    selected: postCategory == PostCategory.GLOBAL,
                    onSelected: (val) {
                      setState(() {
                        postCategory = PostCategory.GLOBAL;
                        bloc.resetPostsFetcher();
                        bloc.fetchPosts();
                      });
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ChoiceChip(
                    label: Text('Feed'),
                    selected: postCategory == PostCategory.FEED,
                    onSelected: (val) {
                      setState(() {
                        if (isLoggedIn) {
                          postCategory = PostCategory.FEED;
                          bloc.resetPostsFetcher();
                          bloc.fetchFeedPosts();
                        } else {
                          scaffoldKey.currentState.hideCurrentSnackBar();
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Padding(
                              padding: EdgeInsets.all(0),
                              child: Text('YOU NEED TO SIGN IN FIRST THOUGH'),
                            ),
                            action: SnackBarAction(label: 'CLOSE', onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar()),
                          ));
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: bloc.posts,
                builder: (_, AsyncSnapshot<List<Post>> asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    var posts = asyncSnapshot.data;
                    return RefreshIndicator(
                      onRefresh: () {
                        bloc.resetPostsFetcher();
                        switch (postCategory) {
                          case PostCategory.GLOBAL:
                            return bloc.fetchPosts();
                          case PostCategory.FEED:
                            return bloc.fetchFeedPosts();
                          default:
                            throw Exception('Umatched case');
                        }
                      },
                      child: ListView(
                        controller: scrollController,
                        children: buildChildren(posts),
                      ),
                    );
                  } else if (asyncSnapshot.hasError) {
                    return Center(child: Column(
                      children: <Widget>[
                        Text(asyncSnapshot.error, style: TextStyle(color: Colors.white),),
                        RaisedButton(
                          child: Text('Refresh'),
                          onPressed: (){
                            setState(() {
                              bloc.resetPostsFetcher();
                              switch (postCategory) {
                                case PostCategory.GLOBAL:
                                  bloc.fetchPosts(); break;
                                case PostCategory.FEED:
                                  bloc.fetchFeedPosts(); break;
                                default:
                                  throw Exception('Umatched case');
                              }
                            });
                          },
                        )
                      ],
                    ));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ));
  }

  List<Widget> buildChildren(List<Post> posts) {
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

  resetSelected(PostCategory postCategory, bool val) {
    if (val == true) {
      for (var key in selected.keys) {
        selected[key] = false;
      }
      selected[postCategory] = val;
      bloc.resetPostsFetcher();
//      switch(selected.keys.singleWhere((key)=>selected[key])){
//        case PostCategory.GLOBAL: bloc.fetchPosts(); break;
//        case PostCategory.FEED: bloc.fetchFeedPosts();break;
//        default: throw Exception('Umatched case');
//      }
    }
  }
}
