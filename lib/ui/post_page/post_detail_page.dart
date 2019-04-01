import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animey/models/comment.dart';
import 'package:animey/models/post.dart';
import 'package:animey/blocs/post_bloc.dart';
import 'package:animey/blocs/user_bloc.dart';
import 'package:animey/ui/post_page/comment_card.dart';
import 'package:animey/ui/post_page/post_card.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage({@required this.post});

  @override
  State<StatefulWidget> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> with TickerProviderStateMixin {
  final userBloc = UserBloc();
  final postBloc = PostBloc();
  final scrollController = ScrollController();
  final textEditingController = TextEditingController();
  bool showInputFAB = false;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    //userBloc.fetchUserInfoByLink(widget.post.relationships.user.links.related);
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        postBloc.fetchComments(widget.post.id);
      }
      setState(() {
        isVisible = false;
      });
    });
    postBloc.fetchComments(widget.post.id);
  }

  @override
  void dispose() {
    super.dispose();
    userBloc.dispose();
    postBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Comments'),
      ),
//      bottomNavigationBar: BottomAppBar(
//        elevation: 4,
//        child: Container(
//          width: MediaQuery.of(context).size.width,
//          child: Flex(
//            direction: Axis.horizontal,
//            children: <Widget>[
//              Flexible(
//                flex: 7,
//                child: TextField(
//                  decoration: InputDecoration(hintText: 'Reply'),
//                ),
//              ),
//              Flexible(
//                flex: 3,
//                child: FlatButton(
//                  child: Icon(Icons.send),
//                ),
//              )
//            ],
//          )
//        )
//      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(children: buildChildren()),
      ),
      floatingActionButton: CustomFAB(
        scrollController: scrollController,
        textEditingController: textEditingController,
        onSubmitted: () {
          if (textEditingController.text.isNotEmpty) {
            postBloc.uploadComment(widget.post.id, textEditingController.text);
            setState(() {
              textEditingController.clear();
              showInputFAB = false;
            });
          }
        },
      ),
//      floatingActionButton: AnimatedOpacity(
//        opacity: isVisible ? 1 : 0,
//        duration: Duration(milliseconds: 300),
//        child: AnimatedContainer(
//          //vsync: this,
//          duration: Duration(milliseconds: 150),
//          child: showInputFAB
//              ? FloatingActionButton.extended(
//                  onPressed: null,
//                  icon: IconButton(
//                      icon: Icon(Icons.send),
//                      onPressed: () {
//                        if (textEditingController.text.isNotEmpty) {
//                          postBloc.uploadComment(widget.post.id, textEditingController.text);
//                          setState(() {
//                            textEditingController.clear();
//                            showInputFAB = false;
//                          });
//                        }
//                      }),
//                  label: Container(
//                      width: MediaQuery.of(context).size.width * 0.7,
//                      child: Flex(
//                        direction: Axis.horizontal,
//                        mainAxisSize: MainAxisSize.max,
//                        children: <Widget>[
//                          Flexible(
//                            flex: 9,
//                            child: TextField(
//                              controller: textEditingController,
//                              decoration: InputDecoration(hintText: 'Reply'),
//                            ),
//                          ),
//                          Flexible(
//                              flex: 1,
//                              child: IconButton(
//                                icon: Icon(Icons.close),
//                                onPressed: () {
//                                  setState(() {
//                                    showInputFAB = false;
//                                  });
//                                },
//                              ))
//                        ],
//                      )))
//              : FloatingActionButton(
//                  heroTag: 'asd',
//                  child: Icon(Icons.create),
//                  onPressed: () {
//                    //showDialog(context: context, builder: (context)=>buildInputDialog(context));
//                    setState(() {
//                      showInputFAB = true;
//                    });
//                  },
//                ),
//        ),
//      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @Deprecated('User FloatingActionButton for now')
  Widget buildInputDialog(BuildContext context) {
    var textEditingController = TextEditingController();
    return Center(
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
            child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Reply"),
              ),
              RaisedButton(
                child: Text('Reply'),
                onPressed: () {
                  Navigator.pop(context);
                  postBloc.uploadComment(widget.post.id, textEditingController.text);
                },
              )
            ],
          ),
        )),
      ),
    );
  }

  List<Widget> buildChildren() {
    var children = List<Widget>();
    children.add(buildMainPost());
    children.add(buildComments());
    children.add(SizedBox(
      height: 72,
    ));
    return children;
  }

  Widget buildMainPost() {
    return Hero(
        tag: widget.post.id,
        child: PostCard(
          post: widget.post,
          keepPadding: false,
          keepCommentButton: false,
        ));
  }

  Widget buildComments() {
    return StreamBuilder(
      stream: postBloc.comments,
      builder: (_, AsyncSnapshot<List<Comment>> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          var comments = asyncSnapshot.data;
          return comments.isEmpty
              ? Container(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No comments found',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Column(
                  children: comments.map((comment) => CommentCard(commment: comment)).toList(),
                );
        } else if (asyncSnapshot.hasError) {
          return Center(child: Text(asyncSnapshot.error));
        } else {
          return Container();
        }
      },
    );
  }
}

class CustomFAB extends StatefulWidget {
  final ScrollController scrollController;
  final TextEditingController textEditingController;
  final VoidCallback onSubmitted;

  CustomFAB({@required this.scrollController, @required this.textEditingController, @required this.onSubmitted});

  @override
  State<StatefulWidget> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  bool showInputFAB = false;
  bool isVisible = true;
  bool isMoving = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (isVisible) {
        Timer(Duration(milliseconds: 300), () {
          if (this.mounted) {
            setState(() {
              isVisible = true;
            });
          }
        });
      }
      setState(() {
        isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: AnimatedContainer(
        //vsync: this,
        duration: Duration(milliseconds: 150),
        child: showInputFAB
            ? FloatingActionButton.extended(
                onPressed: null,
                icon: IconButton(icon: Icon(Icons.send), onPressed: widget.onSubmitted),
                label: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          flex: 9,
                          child: TextField(
                            controller: widget.textEditingController,
                            decoration: InputDecoration(hintText: 'Reply'),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  showInputFAB = false;
                                });
                              },
                            ))
                      ],
                    )))
            : FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: () {
                  //showDialog(context: context, builder: (context)=>buildInputDialog(context));
                  setState(() {
                    showInputFAB = true;
                  });
                },
              ),
      ),
    );
  }
}
