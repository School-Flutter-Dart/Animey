import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:animey/blocs/anime_bloc.dart';
import 'package:animey/blocs/anime_bloc_provider.dart';
import 'package:animey/models/anime.dart';
import 'package:animey/ui/anime_horizontal_listview.dart';
import 'package:animey/ui/anime_gridview_page.dart';
import 'package:animey/ui/streamer_card.dart';
import 'package:animey/anime_info_card.dart';
import 'package:animey/resources/string_values.dart';
import 'package:animey/utils/model_utils.dart';

const SeasonList = <String>["Spring", "Summer", "Fall", "Winter"];
const SeasonFilterStrList = <String>["&filter[season]=spring", "&filter[season]=summer", "&filter[season]=fall", "&filter[season]=winter"];
const RegExpSeasonFilterStrList = <String>[
  "&filter\\[season]=spring",
  "&filter\\[season]=summer",
  "&filter\\[season]=fall",
  "&filter\\[season]=winter"
];

class LibraryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final scrollController = ScrollController();
  final animeBloc = AnimeBloc();
  Utf8Decoder utf8decoder = Utf8Decoder();
  List<Anime> animes = [];
  String filteredUrl;
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        animeBloc.fetchMoreAnimes();
      }
    });

    filteredUrl =
        "https://kitsu.io/api/edge/anime?fields[anime]=posterImage,titles,startDate,episodeCount,episodeLength,canonicalTitle";
    animeBloc.fetchAnimes(filteredUrl, withOnlyPosterImage: false);
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    return buildLibraryPage();
  }

  Widget buildLibraryPage() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -400,
          left: -100,
          child: Container(
            height: 1000,
            width: MediaQuery.of(context).size.width + 200,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
          ),
        ),
        Positioned(
            top: 0,
            child: Container(
                height: MediaQuery.of(context).size.height - 150,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Trending',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300),
                                  ),
                                )),
                            AnimeBlocProvider(
                              child: AnimeHorizantalListView(),
                              link: "https://kitsu.io/api/edge/trending/anime",
                              withOnlyPosterImage: true,
                            ),
                            Container(
                              width: double.infinity,
                              height: 100,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  buildStreamerCard(Amazon),
                                  buildStreamerCard(CrunchyRoll),
                                  buildStreamerCard(Funimation),
                                  buildStreamerCard(HIDIVE),
                                  buildStreamerCard(Hulu),
                                  buildStreamerCard(Netflix),
                                  buildStreamerCard(TubiTV),
                                  buildStreamerCard(Viewster),
                                  buildStreamerCard(YouTube),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: DateTime.now().year - 2000 + 1,
                                  itemBuilder: (_, index) {
                                    int yearNow = DateTime.now().year;
                                    String filterStr = "&filter[year]=${yearNow - index}";
                                    return Padding(
                                      padding: EdgeInsets.only(left: 8, top: 8, bottom: 4),
                                      child: FilterChip(
                                        label: Text('${yearNow - index}'),
                                        selected: filteredUrl.contains(filterStr),
                                        onSelected: (value) {
                                          setState(() {
                                            if (value) {
                                              filteredUrl += filterStr;
                                            } else {
                                              filteredUrl = filteredUrl.replaceAll(RegExp("(&filter\\[year]=" + "${yearNow - index}" + ")"), "");
                                            }
                                          });
                                          refetchData();
                                        },
                                      ),
                                    );
                                  }),
                            ),
                            Container(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: SeasonFilterStrList.length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 8, top: 8),
                                    child: FilterChip(
                                      label: Text(SeasonList[index]),
                                      selected: filteredUrl.contains(SeasonFilterStrList[index]),
                                      onSelected: (value) {
                                        setState(() {
                                          if (value) {
                                            filteredUrl += SeasonFilterStrList[index];
                                          } else {
                                            filteredUrl = filteredUrl.replaceAll(RegExp(RegExpSeasonFilterStrList[index]), "");
                                          }
                                        });
                                        refetchData();
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: StreamBuilder(
                          stream: animeBloc.animes,
                          builder: (_,AsyncSnapshot<List<Anime>> asyncSnapshot){
                            if(asyncSnapshot.hasData){
                              var animes = asyncSnapshot.data;
                              return Column(
                                children: animes.map((anime)=>AnimeInfoCard(anime,tag: anime.id)).toList(),
                              );
                            }else if(asyncSnapshot.hasError){
                              return Center(child: Text(asyncSnapshot.error));
                            }else{
                              return Center(child: LinearProgressIndicator());
                            }
                          },
                        )
                      )
                    ],
                  ),
                )))
      ],
    );
  }

  Widget buildStreamerCard(String streamerName){
    return StreamerCard(
        siteName: streamerName,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AnimeGridViewPage(
                  title: streamerName,
                  streamerId: streamerNameToStreamerIdConverter(streamerName),
                ))));
  }


  refetchData() async {
    //offset = 10;
    //filterUrl = filterUrl.replaceFirst(RegExp("[0-9][0-9]*"), offset.toString());
    animeBloc.resetAnimes();
    animeBloc.fetchAnimes(filteredUrl, withOnlyPosterImage:false);
  }

//  getMoreData() async {
//    if (!isPerformingRequest) {
//      setState(() => isPerformingRequest = true);
//      offset += 10;
//      filterUrl = filterUrl.replaceFirst(RegExp("[0-9][0-9]*"), offset.toString());
//      var bodyBytes = (await http.get(filterUrl)).bodyBytes;
//      List<Anime> newAnimes = animesFromJson(_utf8decoder.convert(bodyBytes));
//      setState(() {
//        animes.addAll(newAnimes);
//        isPerformingRequest = false;
//      });
//    }
//  }

  Widget buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
