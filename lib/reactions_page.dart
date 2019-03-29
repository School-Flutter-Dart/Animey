import 'dart:async';

import 'package:flutter/material.dart';

import 'models/media_reactions.dart';
import 'models/media_reaction_votes_relationships.dart';
import 'utils/http_utils.dart';
import 'package:http/http.dart' as http;

class ReactionsPage extends StatefulWidget {
  final String animeId;
  final int totalReactions;

  ReactionsPage(this.animeId, this.totalReactions);

  @override
  State<StatefulWidget> createState() => ReactionsPageState();
}

class ReactionsPageState extends State<ReactionsPage> {
  final _scrollController = ScrollController();
  //final _client = http.Client();
  List<Reaction> _reactions = [];
  int _offset = 0;
  bool _isPerforming = false;

  @override
  void initState() {
    super.initState();
    if (widget.totalReactions > 10) {
      _scrollController.addListener(() => _getMoreDate());
    }
    _getDate();
  }

  _getDate() async {
    var newReactions = MediaReactions.fromJson(await getRequestAsJson(
            "https://kitsu.io/api/edge/media-reactions?filter[animeId]=${widget.animeId}&page[offset]=$_offset"))
        .reactions;
    setState(() {
      _reactions.addAll(newReactions);
    });
  }

  _getMoreDate() async {
    if (!_isPerforming &&
        _offset < widget.totalReactions &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _isPerforming = true;
      _offset += 10;
      var newReactions = MediaReactions.fromJson(await getRequestAsJson(
              "https://kitsu.io/api/edge/media-reactions?filter[animeId]=${widget.animeId}&page[offset]=$_offset"))
          .reactions;
      setState(() {
        _reactions.addAll(newReactions);
        _isPerforming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reactions'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      child: Column(
        children: _buildReactions(),
      ),
    );
  }

  List<Widget> _buildReactions() {
    return List.generate(_reactions.length, (index) {
      var reaction = _reactions[index];
      //var reactionVoteRelationships = MediaReactionVotesRelationships.fromJson(await getRequestAsJson(reaction.relationships.votes.links.self));
      return ReactionCard(reaction);
    });
  }
}

class ReactionCard extends StatefulWidget {
  final Reaction reaction;

  ReactionCard(this.reaction);

  @override
  State<StatefulWidget> createState() => ReactionCardState();
}

class ReactionCardState extends State<ReactionCard> {
  final _client = http.Client();
  final _streamController = StreamController<_VoteIdAndCount>();
  bool _needReload = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    var json = await getRequestAsJson(
        'https://kitsu.io/api/edge/media-reactions/${widget.reaction.id}/votes');
    var count = json['meta']['count'];
    json =
        await getRequestAsJson(widget.reaction.relationships.votes.links.self);
    var reactionVoteRelations = MediaReactionVotesRelationships.fromJson(json);
    var id = reactionVoteRelations.data.isNotEmpty
        ? reactionVoteRelations.data.first.id
        : "";
      _streamController.add(_VoteIdAndCount(id, count));
      print("upadte is here and voteCount is $count ");
  }

  @override
  void didUpdateWidget(ReactionCard oldWidget) {
    if (_needReload) {
      print("><");
      setState(() {
        load();
        _needReload = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      child: StreamBuilder(
        stream: _streamController.stream,
        builder: (_, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            int totalVotes = (asyncSnapshot.data as _VoteIdAndCount).voteCount;
            String id = (asyncSnapshot.data as _VoteIdAndCount).voteId;
            print("count: $totalVotes");
            return ListTile(
              title: Text(widget.reaction.attributes.reaction.replaceAll("\n", "")),
              subtitle: Text('some user'),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_up),
                  Text(totalVotes.toString())
                ],
              ),
            );
//            return Card(
//                color: Colors.orange[200],
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(0))),
//                child: Container(
//                    width: MediaQuery.of(context).size.width,
//                    child: Padding(
//                        padding: EdgeInsets.all(8),
//                        child: Flex(
//                          direction: Axis.horizontal,
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Flexible(
//                              flex: 1,
//                              child: Text(totalVotes.toString()),
//                            ),
//                            //SizedBox(width: 30,),
//                            Expanded(
//                              flex: 8,
//                              child: Text(widget.reaction.attributes.reaction
//                                  .replaceAll("\n", "")),
//                            ),
//                            IconButton(
//                              icon: Icon(Icons.arrow_upward),
//                              onPressed: () {
////                                var url =
////                                    "https://kitsu.io/api/edge/media-reaction-votes";
////                                var request =
////                                    http.Request('POST', Uri.parse(url));
////                                var bodyStr =
////                                    '{"data":{"type":"mediaReactionVotes","relationships":{"user": {"data": {"type": "users", "id": "460584"}},"mediaReaction":{"data":{"type":"mediaReactions","id":"${widget.reaction.id}"}}}}}';
////                                request.headers["Authorization"] =
////                                    "Bearer 7f3e1665d906aaca078d326f721d81af5814033379317645643042635e258de6";
////                                request.headers["Content-Type"] =
////                                    "application/vnd.api+json";
////                                request.body = bodyStr;
////                                var future = _client
////                                    .send(request)
////                                    .then((response) => response.stream
////                                            .bytesToString()
////                                            .then((value) {
////                                          if (value
////                                              .toString()
////                                              .contains('error')) {
////                                            if (id.isNotEmpty) {
////                                              _handleDeleteUpvote(id);
////                                            }
////                                          }
////                                          //print(value.toString());
////                                        }))
////                                    .catchError((error) {
////                                  //print(error.toString());
////                                }).whenComplete((){
////                                  setState(() {
////                                    load();
////                                    _needReload = true;
////                                  });
////                                });
//
//                              },
//                            )
//                          ],
//                        ))));
          } else {
            return Container();
          }
        },
      ),
    );
  }

//  _handleDeleteUpvote(String voteId) {
//    var deleteUrl = "https://kitsu.io/api/edge/media-reaction-votes/$voteId";
//    //var bodyStr = '{"data":{"type":"mediaReactionVotes","relationships":{"user": {"data": {"type": "users", "id": "460584"}},"mediaReaction":{"data":{"type":"mediaReactions","id":"${reaction.id}"}}}}}';
//    var deleteRequest = http.Request('DELETE', Uri.parse(deleteUrl));
//    deleteRequest.headers["Authorization"] =
//        "Bearer 7f3e1665d906aaca078d326f721d81af5814033379317645643042635e258de6";
//    deleteRequest.headers["Content-Type"] = "application/vnd.api+json";
//    _client.send(deleteRequest).then((res) =>
//        res.stream.bytesToString().then((val) => print(val.toString()))).whenComplete((){
//      setState(() {
//        load();
//        _needReload = true;
//      });
//    });
//  }
}

class _VoteIdAndCount {
  String voteId;
  int voteCount;

  _VoteIdAndCount(this.voteId, this.voteCount);
}
