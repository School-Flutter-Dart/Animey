import 'package:flutter/material.dart';
import 'package:animey/models/library_entries.dart';
import 'package:animey/blocs/library_entries_bloc.dart';
import 'package:animey/blocs/user_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:animey/anime_detail_page.dart';

class MyLibraryEntryPgae extends StatefulWidget {
  final String userId;

  MyLibraryEntryPgae({@required this.userId});

  @override
  State<StatefulWidget> createState() => _MyLibraryEntryPageState();
}

class _MyLibraryEntryPageState extends State<MyLibraryEntryPgae> with SingleTickerProviderStateMixin {
  final libEntryBloc = LibraryEntriesBloc();
  final userBloc = UserBloc();
  TabController tabController;

  Status selectedStatus = Status.COMPLETED;

  @override
  void initState() {
    super.initState();
    //libEntryBloc.fetchLibraryEntriesData(userId: widget.userId);
    libEntryBloc.fetchLibraryEntries(userId: widget.userId);
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: libEntryBloc.libraryEntries,
      builder: (_, AsyncSnapshot<List<LibraryEntry>> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          print("done building library Entry list");
          var libEntries = asyncSnapshot.data;
          print("the length of list: ${libEntries.length}");
          return Scaffold(
            appBar: PreferredSize(
                child: Material(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: TabBar(
                        isScrollable: true,
                        controller: tabController,
                        tabs: [
                          Tab(text: StatusToStringMap[Status.COMPLETED]),
                          Tab(text: StatusToStringMap[Status.CURRENT]),
                          Tab(text: StatusToStringMap[Status.DROPPED]),
                          Tab(text: StatusToStringMap[Status.ONHOLD]),
                          Tab(text: StatusToStringMap[Status.PLANNED]),
                        ],
                        onTap: resetSelected,
                      ),
                    )),
                preferredSize: Size.fromHeight(100)),
            body: TabBarView(controller: tabController, children: [
              buildLibraryEntryList(Status.COMPLETED, libEntries),
              buildLibraryEntryList(Status.CURRENT, libEntries),
              buildLibraryEntryList(Status.DROPPED, libEntries),
              buildLibraryEntryList(Status.ONHOLD, libEntries),
              buildLibraryEntryList(Status.PLANNED, libEntries),
            ]),
          );
        } else {
          print("building library Entry list");
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  resetSelected(int index) {
    switch (index) {
      case 0:
        selectedStatus = Status.COMPLETED;
        break;
      case 1:
        selectedStatus = Status.CURRENT;
        break;
      case 2:
        selectedStatus = Status.DROPPED;
        break;
      case 3:
        selectedStatus = Status.ONHOLD;
        break;
      case 4:
        selectedStatus = Status.PLANNED;
        break;
      default:
        throw Exception('Index not matched');
    }
  }

  Widget buildLibraryEntryList(Status status, List<LibraryEntry> libEntries) {
    var targetedEntries = libEntries.where((entry) => entry.attributes.status == status).toList();
//    return AnimatedList(itemBuilder: (_, index, __) {
//      var entry = targetedEntries[index];
//      return Material(
//        child: InkWell(
//          onTap: () {
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (_) => AnimeDetailPage(
//                          animeId: entry.relationships.animeId,
//                          tag: "entry" + entry.relationships.animeId,
//                        )));
//          },
//          child: Flex(
//            direction: Axis.horizontal,
//            children: <Widget>[
//              Container(
//                  height: 150,
//                  child: Hero(
//                    tag: "entry" + entry.anime.id,
//                    child: FadeInImage.memoryNetwork(
//                      fit: BoxFit.fill,
//                      placeholder: kTransparentImage,
//                      image: entry.anime.attributes.posterImage.small,
//                    ),
//                  )),
//              Expanded(
//                child: Column(
//                  mainAxisSize: MainAxisSize.max,
//                  children: <Widget>[
//                    Text(
//                      entry.anime.attributes.canonicalTitle,
//                      style: TextStyle(fontWeight: FontWeight.bold),
//                      textAlign: TextAlign.center,
//                    ),
//                    Padding(
//                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                        child: Stack(
//                          alignment: Alignment.center,
//                          children: <Widget>[
//                            Align(
//                              alignment: Alignment.center,
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  FlatButton(
//                                    child: Icon(Icons.remove),
//                                    onPressed: () {
//                                      ///TODO: implement
//                                    },
//                                  ),
//                                  Text('${entry.attributes.progress}/${entry.anime.attributes.episodeCount}'),
//                                  FlatButton(
//                                    child: Icon(Icons.add),
//                                    onPressed: () {
//                                      ///TODO: implement
//                                    },
//                                  )
//                                ],
//                              ),
//                            ),
//                          ],
//                        )),
//                    Padding(
//                      padding: EdgeInsets.symmetric(horizontal: 12),
//                      child: LinearProgressIndicator(
//                        value: entry.attributes.progress / (entry.anime.attributes.episodeCount == null ? 1 : entry.anime.attributes.episodeCount),
//                      ),
//                    )
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//      );
//    });
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
                              isFromLibrary: true,
                              libraryEntry: entry,
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
                                      FlatButton(
                                        child: Icon(Icons.remove),
                                        onPressed: () {
                                          ///TODO: implement
                                        },
                                      ),
                                      Text('${entry.attributes.progress}/${entry.anime.attributes.episodeCount}'),
                                      FlatButton(
                                        child: Icon(Icons.add),
                                        onPressed: () {
                                          ///TODO: implement
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: LinearProgressIndicator(
                            value:
                                entry.attributes.progress / (entry.anime.attributes.episodeCount == null ? 1 : entry.anime.attributes.episodeCount),
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
  }
}
