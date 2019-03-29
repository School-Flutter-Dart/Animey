import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:animey/blocs/user_bloc.dart';
import 'package:animey/models/user.dart';
import 'package:animey/models/comment.dart';
import 'package:animey/ui/user_page/user_page.dart';
import 'package:animey/utils/time_utils.dart';
import 'package:animey/utils/http_utils.dart';

class CommentCard extends StatefulWidget {
  final Comment commment;

  CommentCard({@required this.commment});

  @override
  State<StatefulWidget> createState() => CommentCardState();
}

class CommentCardState extends State<CommentCard> {
  final userBloc = UserBloc();
  double opacity = 0;

  @override
  void initState() {
    super.initState();

    if (widget.commment.relationships == null) {
      userBloc.fetchLoggedInUserInfo();
    } else {
      userBloc.fetchUserInfoByLink(widget.commment.relationships.user.links.related);
    }
    Timer(Duration(milliseconds: 500), () {
      if (this.mounted) {
        setState(() {
          opacity = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    userBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 500),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: double.infinity,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: StreamBuilder(
                          stream: userBloc.userInfo,
                          builder: (_, AsyncSnapshot<User> asyncSnapshot) {
                            if (asyncSnapshot.hasData) {
                              User user = asyncSnapshot.data;
                              return Stack(
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => UserPage(
                                                    user: user,
                                                    userName: user.attributes.name,
                                                    userId: user.id,
                                                    userAvatarLink: user.attributes.avatar == null ? NullAvatarUrl : user.attributes.avatar.medium,
                                                  ))),
                                          child: ClipOval(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child: FadeInImage.memoryNetwork(
                                                  placeholder: kTransparentImage,
                                                  image: user.attributes.avatar == null ? NullAvatarUrl : user.attributes.avatar.medium),
                                            ),
                                          )
//                                child: CircleAvatar(
//                                  backgroundImage: NetworkImage(user.attributes.avatar == null ? NullAvatarUrl : user.attributes.avatar.medium),
//                                ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        user.attributes.name,
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      getTimeDifference(widget.commment.attributes.createdAt),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                    Divider(height: 0,),
//                    SizedBox(
//                      height: 12,
//                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(
                        widget.commment.attributes.content ?? "",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    widget.commment.attributes.embed == null
                        ? Container()
                        : FlatButton(
                            child: Text(widget.commment.attributes.embed.title, style: TextStyle(color: Colors.blue)),
                            onPressed: () async => launchURL(widget.commment.attributes.embed.url),
                          ),
                    //widget.post.attributes.embed == null ? Container() : Text('url: '+ widget.post.attributes.embed.url),
                    //widget.post.attributes.embed == null ? Container() : Text('title: '+widget.post.attributes.embed.title),
                    widget.commment.attributes.embed == null
                        ? Container()
                        : widget.commment.attributes.embed.image == null
                            ? Container()
                            : FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: widget.commment.attributes.embed.image.url),
//                    SizedBox(
//                      height: 12,
//                    ),
                    Divider(
                      height: 0,
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: InkWell(
                                child: Container(
                                    child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                )),
                                onTap: () {},
                              ),
                            )),
                        Transform.rotate(
                          angle: pi / 2,
                          child: Container(
                            width: 30,
                            child: Divider(),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              child: Container(
                                  child: Icon(
                                Icons.message,
                                color: Colors.grey,
                              )),
                              onTap: () {
                                ///TODO:
                              },
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
