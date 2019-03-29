import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'models/media_reactions.dart';
import 'models/user.dart';
import 'reactions_page.dart';
import 'blocs/user_bloc_provider.dart';
import 'blocs/user_bloc.dart';

class ReactionsSection extends StatefulWidget {
  final MediaReactions mediaReactions;
  final String animeId;

  ReactionsSection(this.mediaReactions, this.animeId);

  @override
  State<StatefulWidget> createState() => _ReactionsSectionState();
}

class _ReactionsSectionState extends State<ReactionsSection> {
  final _scrollController = ScrollController();
  //List<Widget> rowChildren;
  List<UserBlocProvider> userBlocProviders = List<UserBlocProvider>(); // for dispose
  double _angle = math.pi;
  double _opacity = 0;
  bool _fabIsAvailable = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaReactions.meta.count >= 10) {
      _scrollController.addListener(_scrollListener);
    } else {
      _opacity = 1;
      _angle = 0;
      _fabIsAvailable = true;
    }
//    rowChildren = widget.mediaReactions.reactions.map((reaction) {
//      var blocProvider = UserBlocProvider(child: ReactionCard(reaction: reaction));
//      userBlocProviders.add(blocProvider);
//      return blocProvider;
//    }).toList();
  }

  @override
  void dispose() {
    userBlocProviders.forEach((blocProvider)=>blocProvider.userBloc.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: double.infinity,
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
            elevation: 2,
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: widget.mediaReactions.reactions.isEmpty
                          ? Center(
                              child: Text(
                              '¯\\_(ツ)_/¯\nNo reactions',
                              textAlign: TextAlign.center,
                            ))
                          : SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: buildRowChildren(widget.mediaReactions.reactions),),
                            ),
                    ),
                    Positioned(
                        top: 100,
                        right: 24,
                        child: Transform.rotate(
                            angle: _angle,
                            child: Opacity(
                              opacity: _opacity,
                              child: FloatingActionButton(
                                  child: Icon(Icons.chevron_right),
                                  onPressed: () {
                                    if (_fabIsAvailable)
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => ReactionsPage(widget.animeId, widget.mediaReactions.meta.count)));
                                  }),
                            )))
                  ],
                ))),
      ),
    );
  }

  List<Widget> buildRowChildren(List<Reaction> reactions) {
    return reactions.map((reaction) {
      print(reaction.id);
      return ReactionCard(reaction: reaction);
    }).toList();
  }

  void _scrollListener() {
    setState(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
        _fabIsAvailable = true;
      } else {
        _fabIsAvailable = false;
      }
    });

    if (_scrollController.offset > 2000) {
      double rate = (_scrollController.position.maxScrollExtent - _scrollController.offset) / (_scrollController.position.maxScrollExtent - 2000);

      setState(() {
        _angle = math.pi * rate;
        _opacity = 1 - rate;
      });
    } else {
      setState(() {
        _angle = math.pi;
        _opacity = 0;
      });
    }
  }
}

class ReactionCard extends StatefulWidget{
  final Reaction reaction;

  ReactionCard({@required this.reaction});

  @override
  State<StatefulWidget> createState() =>_ReactionCardState();
}

class _ReactionCardState extends State<ReactionCard> {
  final userBloc = UserBloc();

  @override
  void initState() {
    super.initState();

    userBloc.fetchUserInfoByLink(widget.reaction.relationships.user.links.related);
  }

  @override
  void dispose() {
    //userBloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.orange[200],
        child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(8),
                    child: StreamBuilder(
                      stream: userBloc.userInfo,
                      builder: (_, AsyncSnapshot<User> asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          User user = asyncSnapshot.data;
                          return CircleAvatar(
                            backgroundImage: NetworkImage(user.attributes.avatar==null?NullAvatarUrl:user.attributes.avatar.medium),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    widget.reaction.attributes.reaction.replaceAll("\n", ""),
                    maxLines: 4,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StreamBuilder(
                          stream: userBloc.userInfo,
                          builder: (_, AsyncSnapshot<User> asyncSnapshot) {
                            if (asyncSnapshot.hasData) {
                              User user = asyncSnapshot.data;
                              return Text(
                                user.attributes.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black54),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        Text('${widget.reaction.attributes.createdAt.substring(0, 10)}', style: TextStyle(color: Colors.black54))
                      ],
                    ))
              ],
            )));
  }
}
