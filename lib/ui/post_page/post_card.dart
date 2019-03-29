import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:animey/models/upload.dart';
import 'package:animey/models/user.dart';
import 'package:animey/models/post.dart';
import 'package:animey/anime_detail_page.dart';
import 'package:animey/ui/post_page/post_detail_page.dart';
import 'package:animey/ui/user_page/user_page.dart';
import 'package:animey/utils/time_utils.dart';
import 'package:animey/utils/http_utils.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool keepPadding;
  final bool keepCommentButton;
  final double padding;

  PostCard({@required this.post, @required this.keepPadding, this.keepCommentButton = true, this.padding = 0});

  @override
  State<StatefulWidget> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isFaved = false;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      if (this.mounted) {
        setState(() {
          opacity = 1;
        });
      }
    });
    //this.userBloc.fetchUserInfoByLink(widget.post.relationships.user.links.related);
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    opacity = 1;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    //this.userBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.keepPadding) {
      return AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 500),
        child: Container(
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.padding),
              child: Card(elevation: 8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))), child: buildMainLayout())),
        ),
      );
    } else {
      return Material(
        elevation: 4,
        child: Container(width: double.infinity, color: Colors.white, child: buildMainLayout()),
      );
    }
  }

  Widget buildMainLayout() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserPage(
                                          user: widget.post.user,
                                          userName: widget.post.user.attributes.name,
                                          userId: widget.post.user.id,
                                          userAvatarLink:
                                              widget.post.user.attributes.avatar == null ? NullAvatarUrl : widget.post.user.attributes.avatar.medium,
                                        ))),
                            child: ClipOval(
                              child: Container(
                                height: 50,
                                width: 50,
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: widget.post.user.attributes.avatar == null ? NullAvatarUrl : widget.post.user.attributes.avatar.medium),
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
                          widget.post.user.attributes.name,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        getTimeDifference(widget.post.attributes.createdAt),
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                )),
          ),
          Divider(
            height: 0,
          ),
//          SizedBox(
//            height: 12,
//          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: widget.post.anime == null
                ? Container()
                : FlatButton(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 100,
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: widget.post.anime.attributes.posterImage.medium,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: Container(
                                  child: Text(
                                    widget.post.anime.attributes.canonicalTitle,
                                    softWrap: true,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AnimeDetailPage(
                                  animeId: widget.post.anime.id,
                                  tag: "post" + widget.post.anime.id,
                                ))),
                  ),
          ),
//          SizedBox(
//            height: 12,
//          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              widget.post.attributes.content == null ? "No Text" : getContentWithoutUrl(widget.post),
              textAlign: TextAlign.left,
            ),
          ),
          widget.post.attributes.embed == null
              ? Container()
              : FlatButton(
                  child: Text(widget.post.attributes.embed.title, style: TextStyle(color: Colors.blue)),
                  onPressed: () async => launchURL(widget.post.attributes.embed.url),
                ),
          widget.post.attributes.embed == null || widget.post.attributes.embed.image == null
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  //height: widget.post.attributes.embed.image.height,
                  child:
                      FadeInImage.memoryNetwork(fit: BoxFit.fitWidth, placeholder: kTransparentImage, image: widget.post.attributes.embed.image.url),
                ),
//          SizedBox(
//            height: 12,
//          ),
          buildUploadSection(widget.post.uploads),
//          SizedBox(
//            height: 12,
//          ),
          Divider(
            height: 0,
          ),
          widget.keepCommentButton
              ? Flex(
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
                        child: Divider(
                          height: 0,
                        ),
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
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailPage(post: widget.post)));
                          },
                        )),
                  ],
                )
              : Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: InkWell(
                      child: Container(
                          child: Icon(
                            isFaved ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          )),
                      onTap: () {
                        setState(() {
                          isFaved = !isFaved;
                        });
                      },
                    ),
                  )
                )
        ],
      ),
    );
//    return Padding(
//      padding: EdgeInsets.all(12),
//      child: Column(
//        children: <Widget>[
//          Align(
//            alignment: Alignment.centerLeft,
//            child: StreamBuilder(
//              stream: userBloc.userInfo,
//              builder: (_, AsyncSnapshot<User> asyncSnapshot) {
//                if (asyncSnapshot.hasData) {
//                  User user = asyncSnapshot.data;
//                  Timer(Duration(seconds: 1), (){
//                    if(this.mounted) {
//                      setState(() {
//                        opacity = 1;
//                      });
//                    }
//                  });
//                  return Stack(
//                    children: <Widget>[
//                      Row(
//                        mainAxisSize: MainAxisSize.max,
//                        children: <Widget>[
//                          GestureDetector(
//                              onTap: () => Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (_) => UserPage(
//                                            user: user,
//                                            userName: user.attributes.name,
//                                            userId: user.id,
//                                            userAvatarLink: user.attributes.avatar == null ? NullAvatarUrl : user.attributes.avatar.medium,
//                                          ))),
//                              child: ClipOval(
//                                child: Container(
//                                  height: 50,
//                                  width: 50,
//                                  child: FadeInImage.memoryNetwork(
//                                      placeholder: kTransparentImage,
//                                      image: user.attributes.avatar == null ? NullAvatarUrl : user.attributes.avatar.medium),
//                                ),
//                              )
////                                child: CircleAvatar(
////                                  backgroundImage: NetworkImage(user.attributes.avatar == null ? NullAvatarUrl : user.attributes.avatar.medium),
////                                ),
//                              ),
//                          SizedBox(
//                            width: 8,
//                          ),
//                          Text(
//                            user.attributes.name,
//                            style: TextStyle(fontWeight: FontWeight.w500),
//                          ),
//                        ],
//                      ),
//                      Align(
//                        alignment: Alignment.centerRight,
//                        child: Text(
//                          getTimeDifference(widget.post.attributes.createdAt),
//                          style: TextStyle(color: Colors.grey),
//                        ),
//                      )
//                    ],
//                  );
//                } else {
//                  return Container();
//                }
//              },
//            ),
//          ),
//          Divider(),
//          SizedBox(
//            height: 12,
//          ),
//          widget.post.anime == null
//              ? Container()
//              : FlatButton(
//                  child: Padding(
//                      padding: EdgeInsets.all(8),
//                      child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        child: Row(
//                          children: <Widget>[
//                            Container(
//                              height: 100,
//                              child: FadeInImage.memoryNetwork(
//                                placeholder: kTransparentImage,
//                                image: widget.post.anime.attributes.posterImage.medium,
//                                fit: BoxFit.fill,
//                              ),
//                            ),
//                            SizedBox(
//                              width: 12,
//                            ),
//                            Flexible(
//                              child: Container(
//                                child: Text(
//                                  widget.post.anime.attributes.canonicalTitle,
//                                  softWrap: true,
//                                ),
//                              ),
//                            )
//                          ],
//                        ),
//                      )),
//                  onPressed: () => Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (_) => AnimeDetailPage(
//                                animeId: widget.post.anime.id,
//                                tag: "post" + widget.post.anime.id,
//                              ))),
//                ),
//          SizedBox(
//            height: 12,
//          ),
//          Text(
//            widget.post.attributes.content == null ? "No Text" : getContentWithoutUrl(widget.post),
//            textAlign: TextAlign.left,
//          ),
//          widget.post.attributes.embed == null
//              ? Container()
//              : FlatButton(
//                  child: Text(widget.post.attributes.embed.title, style: TextStyle(color: Colors.blue)),
//                  onPressed: () async => launchURL(widget.post.attributes.embed.url),
//                ),
//          widget.post.attributes.embed == null
//              ? Container()
//              : widget.post.attributes.embed.image == null
//                  ? Container()
//                  : FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: widget.post.attributes.embed.image.url),
//          SizedBox(
//            height: 12,
//          ),
//          buildUploadSection(widget.post.uploads),
//          SizedBox(
//            height: 12,
//          ),
//          Divider(),
//          Flex(
//            direction: Axis.horizontal,
//            children: <Widget>[
//              Expanded(
//                  flex: 1,
//                  child: InkWell(
//                    child: Container(
//                        child: Icon(
//                      Icons.favorite_border,
//                      color: Colors.red,
//                    )),
//                    onTap: () {},
//                  )),
//              Transform.rotate(
//                angle: pi / 2,
//                child: Container(
//                  width: 30,
//                  child: Divider(),
//                ),
//              ),
//              Expanded(
//                  flex: 1,
//                  child: InkWell(
//                    child: Container(
//                        child: Icon(
//                      Icons.message,
//                      color: Colors.grey,
//                    )),
//                    onTap: () {
//                      Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailPage(post: widget.post)));
//                    },
//                  )),
//            ],
//          )
//        ],
//      ),
//    );
  }

  Widget buildUploadSection(List<Upload> uploads) {
    if (uploads.isNotEmpty) {
      var children = List<Widget>();
      int crossAxisCount;
      //int height = 300;
      if (uploads.length >= 3) {
        crossAxisCount = 3;
        //height = 100;
      } else
        crossAxisCount = uploads.length;
      for (var upload in uploads) {
        children.add(FlatButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _PicturePage(url: upload.attributes.content.original))),
            child: Container(
              width: 300,
              height: 300,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: upload.attributes.content.original,
                fit: BoxFit.fitHeight,
              ),
            )));
      }
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        //child: SingleChildScrollView(scrollDirection: Axis.horizontal,child:Row(children: children,)),
        child: GridView(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount),
          children: children,
        ),
      );
    } else {
      return Container();
    }
  }
}

class _PicturePage extends StatelessWidget {
  final String url;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _PicturePage({@required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
            context: context,
            builder: (_) => ListTile(
                title: Text('Save'),
                onTap: () {
                  Navigator.pop(context);
                  saveImage(url);
                }));
      },
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.black,
          body: Center(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: url,
              fit: BoxFit.contain,
            ),
          )),
    );
  }

  saveImage(String url) async {
    // Saved with this method.
    var imageId = await ImageDownloader.downloadImage(url).then((imageId) async {
      String path = await ImageDownloader.findPath(imageId);
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Saved to $path")));
    });
    if (imageId == null) {
      return;
    }

    // Below is a method of obtaining saved image information.
//    var fileName = await ImageDownloader.findName(imageId);
//    var path = await ImageDownloader.findPath(imageId);
//    var size = await ImageDownloader.findByteSize(imageId);
//    var mimeType = await ImageDownloader.findMimeType(imageId);
  }
}
