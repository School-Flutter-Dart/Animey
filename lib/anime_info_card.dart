
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:animey/models/anime.dart';
import 'blocs/anime_bloc_provider.dart';
import 'models/library_entries.dart';
import 'anime_detail_page.dart';

const defaultTextStyle = TextStyle(color: Colors.black);

class AnimeInfoCard extends StatefulWidget{
  final Anime anime;
  String tag = "";
  VoidCallback onTapCallback;
  bool isFromLibrary;
  LibraryEntry libraryEntry;

  AnimeInfoCard(this.anime, {this.tag, this.onTapCallback, this.isFromLibrary = false, this.libraryEntry}):assert((isFromLibrary&&libraryEntry!=null)||(!isFromLibrary));

  @override
  State<StatefulWidget> createState() => _AnimeInfoCardState();

}

class _AnimeInfoCardState extends State<AnimeInfoCard> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
//    Timer(Duration(milliseconds: 100), (){
//      if(this.mounted){
//        setState(() {
//          opacity = 1;
//        });
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    if(false){
      return StreamBuilder(
        stream: AnimeBlocProvider.of(context).anime,
        builder: (_, AsyncSnapshot<Anime> snapshot) {
          if (snapshot.hasData) {
            var anime = snapshot.data;
            widget.tag = anime.id;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: InkWell(
                    onTap: () {
                      //showResults(context);
                      if (widget.onTapCallback != null) widget.onTapCallback();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnimeBlocProvider(
                                child: AnimeDetailPage(
                                  tag: widget.tag,
                                  animeId: anime.id,
                                  isFromLibrary: widget.isFromLibrary,
                                  libraryEntry: widget.libraryEntry,
                                ),
                              ),
                              maintainState: true));
                    },
                    child: Flex(
                      mainAxisSize: MainAxisSize.max,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Flexible(
                            flex: 4,
                            child: Padding(
                                padding: EdgeInsets.all(0),
                                child: Hero(
                                  tag: widget.tag,
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: anime.attributes.posterImage.small,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                        Expanded(
                          flex: 6,
                          child: Container(
                              height: 210,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        anime.attributes.titles.jaJp??"",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: 'Noto'),
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        anime.attributes.canonicalTitle,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: defaultTextStyle,
                                      ),
                                    ),
                                    Divider(),
//                                    Text(
//                                      anime.attributes.startDate??"",
//                                      textAlign: TextAlign.left,
//                                      style: defaultTextStyle,
//                                    ),
//                                    anime.attributes.ratingRank==null?Container():Text(
//                                      "Rating Rank: " +
//                                          anime.attributes.ratingRank.toString(),
//                                      textAlign: TextAlign.left,
//                                      style: defaultTextStyle,
//                                    ),
//                                    anime.attributes.episodeCount==null?Container():Text(
//                                      "Episodes: ${anime.attributes.episodeCount}",
//                                      textAlign: TextAlign.left,
//                                      style: defaultTextStyle,
//                                    ),
//                                    anime.attributes.episodeLength==null?Container():Text(
//                                      "Length: ${anime.attributes.episodeLength} mins",
//                                      textAlign: TextAlign.left,
//                                      style: defaultTextStyle,
//                                    ),
                                    buildRow(context,"Start Date", anime.attributes.startDate),
                                    Divider(),
                                    buildRow(context,"Rating Rank", anime.attributes.ratingRank==null?"":anime.attributes.ratingRank),
                                    Divider(),
                                    buildRow(context,"Episodes", anime.attributes.episodeCount==null?"":anime.attributes.episodeCount.toString()),
                                    Divider(),
                                    buildRow(context,"Length", anime.attributes.episodeLength==null?"":anime.attributes.episodeLength.toString()),
                                    //Text("Genre: ${animes[i].genre.data.attributes.name}",style: defaultTextStyle,)
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  )),
            );
          }else{
            return LinearProgressIndicator();
          }
        },
      );
    }
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            child: InkWell(
              onTap: () {
                //showResults(context);
                if (widget.onTapCallback != null) widget.onTapCallback();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimeBlocProvider(
                          child: AnimeDetailPage(
                            tag: widget.tag,
                            animeId: widget.anime.id,
                            isFromLibrary: widget.isFromLibrary,
                            libraryEntry: widget.libraryEntry,
                          ),
                        ),
                        maintainState: true));
              },
              child: Flex(
                mainAxisSize: MainAxisSize.max,
                direction: Axis.horizontal,
                children: <Widget>[
                  Flexible(
                      flex: 4,
                      child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Hero(
                            tag: widget.tag,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: widget.anime.attributes.posterImage==null?"https://kitsu.io/images/default_poster-1b01bdbe4417916e7fc16ab2f0bc1fe6.jpg":widget.anime.attributes.posterImage.medium,
                                  ),
                                ),
                              ],
                            ),
                          ))),
                  Expanded(
                    flex: 6,
                    child: Container(
                        height: 210,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Text(
                                  widget.anime.attributes.titles.jaJp??"",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Noto'),
                                ),
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  widget.anime.attributes.canonicalTitle,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: defaultTextStyle,
                                ),
                              ),
                              Divider(),
//                            Text(
//                              anime.attributes.startDate??"",
//                              textAlign: TextAlign.left,
//                              style: defaultTextStyle,
//                            ),
//                            anime.attributes.ratingRank==null?Container():Text(
//                              "Rating Rank: " +
//                                  anime.attributes.ratingRank.toString(),
//                              textAlign: TextAlign.left,
//                              style: defaultTextStyle,
//                            ),
//                            anime.attributes.episodeCount==null?Container():Text(
//                              "Episodes: ${anime.attributes.episodeCount}",
//                              textAlign: TextAlign.left,
//                              style: defaultTextStyle,
//                            ),
//                            anime.attributes.episodeLength==null?Container():Text(
//                              "Length: ${anime.attributes.episodeLength} mins",
//                              textAlign: TextAlign.left,
//                              style: defaultTextStyle,
//                            ),
                              buildRow(context,"Start Date", widget.anime.attributes.startDate),
                              Divider(),
                              buildRow(context,"Rating Rank", widget.anime.attributes.ratingRank==null?"":widget.anime.attributes.ratingRank.toString()),
                              Divider(),
                              buildRow(context,"Episodes", widget.anime.attributes.episodeCount==null?"":widget.anime.attributes.episodeCount.toString()),
                              Divider(),
                              buildRow(context,"Length", widget.anime.attributes.episodeLength==null?"":widget.anime.attributes.episodeLength.toString()),
                              //Text("Genre: ${animes[i].genre.data.attributes.name}",style: defaultTextStyle,)
                            ],
                          ),
                        )),
                  )
                ],
              ),
            )),
      ),
    );
  }

  ///build rows for the anime info part
  Widget buildRow(context,String title, String info) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              info ?? "",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
