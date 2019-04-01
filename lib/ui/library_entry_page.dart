import 'package:flutter/material.dart';
import 'package:animey/models/library_entries.dart';
import 'package:animey/blocs/library_entries_bloc.dart';
import 'package:animey/blocs/user_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:animey/anime_detail_page.dart';

class LibraryEntryPgae extends StatefulWidget {
  final String userId;

  LibraryEntryPgae({@required this.userId});

  @override
  State<StatefulWidget> createState() => _LibraryEntryPageState();
}

class _LibraryEntryPageState extends State<LibraryEntryPgae> {
  final libEntryBloc = LibraryEntriesBloc();
  final userBloc = UserBloc();
  Map<Status, bool> selected = Map<Status, bool>();

  @override
  void initState() {
    super.initState();
    //libEntryBloc.fetchLibraryEntriesData(userId: widget.userId);
    libEntryBloc.fetchLibraryEntries(userId: widget.userId);
    selected[Status.COMPLETED] = true;
    selected[Status.CURRENT] = false;
    selected[Status.PLANNED] = false;
    selected[Status.ONHOLD] = false;
    selected[Status.DROPPED] = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                ChoiceChip(
                  label: Text('Completed'),
                  selected: selected[Status.COMPLETED],
                  onSelected: (val) {
                    setState(() {
                      resetSelected(Status.COMPLETED, val);
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                ChoiceChip(
                  label: Text('Current'),
                  selected: selected[Status.CURRENT],
                  onSelected: (val) {
                    setState(() {
                      resetSelected(Status.CURRENT, val);
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                ChoiceChip(
                  label: Text('Dropped'),
                  selected: selected[Status.DROPPED],
                  onSelected: (val) {
                    setState(() {
                      resetSelected(Status.DROPPED, val);
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                ChoiceChip(
                  label: Text('On Hold'),
                  selected: selected[Status.ONHOLD],
                  onSelected: (val) {
                    setState(() {
                      resetSelected(Status.ONHOLD, val);
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                ChoiceChip(
                  label: Text('Planned'),
                  selected: selected[Status.PLANNED],
                  onSelected: (val) {
                    setState(() {
                      resetSelected(Status.PLANNED, val);
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              color: Colors.white,
              child: buildLibraryEntryList(),
            ),
          )
        ],
      ),
    );
  }

  resetSelected(Status status, bool val) {
    if (val == true) {
      for (var key in selected.keys) {
        selected[key] = false;
      }
      selected[status] = val;
    }
  }

  Widget buildLibraryEntryList() {
    print("building library Entry list");
    Status targetedStatus = selected.keys.where((key) => selected[key]).single;
    return StreamBuilder(
      stream: libEntryBloc.libraryEntries,
      builder: (_, AsyncSnapshot<List<LibraryEntry>> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          print("done building library Entry list");
          var libEntries = asyncSnapshot.data;
          print("the length of list: ${libEntries.length}");
          var targetedEntries = libEntries.where((entry) => entry.attributes.status == targetedStatus).toList();
          return ListView.separated(
              itemBuilder: (_, index) {
                var entry = targetedEntries[index];
                return Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AnimeDetailPage(
                                    animeId: entry.relationships.animeId,
                                    tag: "entry" + entry.relationships.animeId,
                                  )));
                    },
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Container(
                            height: 150,
                            child: Hero(
                              tag: "entry" + entry.anime.id,
                              child: FadeInImage.memoryNetwork(
                                fit: BoxFit.fill,
                                placeholder: kTransparentImage,
                                image: entry.anime.attributes.posterImage.small,
                              ),
                            )),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                entry.anime.attributes.canonicalTitle,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('${entry.attributes.progress}/${entry.anime.attributes.episodeCount}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: LinearProgressIndicator(
                                  value: entry.attributes.progress /
                                      (entry.anime.attributes.episodeCount == null ? 1 : entry.anime.attributes.episodeCount),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => Divider(
                    height: 0,
                  ),
              itemCount: targetedEntries.length);
        } else {
          print("building library Entry list");
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

//  Widget buildLibraryEntryList() {
//    print("building library Entry list");
//    Status targetedStatus = selected.keys.where((key) => selected[key]).single;
//    return StreamBuilder(
//      stream: libEntryBloc.libraryEntriesData,
//      builder: (_, AsyncSnapshot<LibraryEntriesData> asyncSnapshot) {
//        if (asyncSnapshot.hasData) {
//          print("done building library Entry list");
//          var libEntries = asyncSnapshot.data.data;
//          print("the length of list: ${libEntries.length}");
//          var targetedEntries = libEntries.where((entry) => entry.attributes.status == targetedStatus).toList();
//          return ListView.separated(
//              itemBuilder: (_, index) {
//                var entry = targetedEntries[index];
//                return Container(
//                  color: Colors.white,
//                  child: ListTile(
//                    onTap: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (_) => AnimeDetailPage(
//                                    animeId: entry.relationships.animeId,
//                                    tag: "entry" + entry.relationships.animeId,
//                                  )));
//                    },
//                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                    leading: Container(
//                        height: 80,
//                        child: Hero(
//                          tag: "entry" + entry.anime.id,
//                          child: FadeInImage.memoryNetwork(
//                            fit: BoxFit.contain,
//                            placeholder: kTransparentImage,
//                            image: entry.anime.attributes.posterImage.small,
//                          ),
//                        )),
//                    title: Text(entry.anime.attributes.canonicalTitle),
//                    subtitle: LinearProgressIndicator(
//                      value: entry.attributes.progress / (entry.anime.attributes.episodeCount == null ? 1 : entry.anime.attributes.episodeCount),
//                    ),
//                  ),
//                );
//              },
//              separatorBuilder: (_, index) => Divider(),
//              itemCount: targetedEntries.length);
//        } else {
//          print("building library Entry list");
//          return Center(child: CircularProgressIndicator());
//        }
//      },
//    );
//  }
}
