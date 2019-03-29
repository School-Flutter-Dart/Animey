import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/anime.dart';
import 'models/episode.dart';
import 'models/streaming_link.dart';
import 'models/media_reactions.dart';
import 'models/post.dart' as PostModel;
import 'package:animey/models/genre.dart';
import 'models/library_entries.dart';
import 'blocs/library_entries_bloc.dart';
import 'blocs/anime_bloc_provider.dart';
import 'blocs/anime_bloc.dart';
import 'blocs/post_bloc.dart';
import 'utils/http_utils.dart';
import 'package:http/http.dart';
import 'package:animey/reactions_section.dart';
import 'ui/streamer_card.dart';

import 'models/category.dart';

import 'ui/anime_gridview_page.dart';
import 'ui/post_page/post_card.dart';

class BackIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final ScrollController scrollController;

  BackIconButton(this.onTap, this.scrollController);

  @override
  State<StatefulWidget> createState() {
    return BackIconButtonState();
  }
}

class BackIconButtonState extends State<BackIconButton> {
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset < 160) {
        setState(() {
          _opacity = (160 - widget.scrollController.offset) / 160;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 24,
        left: 8,
        child: Opacity(
          opacity: _opacity,
          child: IconButton(icon: Icon(Icons.arrow_back), onPressed: _opacity == 0 ? () {} : widget.onTap),
        ));
  }
}

class BackdropPoster extends StatefulWidget {
  final Anime anime;
  final ScrollController scrollController;

  BackdropPoster(this.anime, this.scrollController);

  @override
  State<StatefulWidget> createState() {
    return BackdropPosterState();
  }
}

class BackdropPosterState extends State<BackdropPoster> {
  double _opacity = 1;
  double _sigma = 0;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      if (widget.scrollController.offset < 160) {
        setState(() {
          _opacity = (160 - widget.scrollController.offset) / 160;
          _sigma = 10 - _opacity * 10;
        });
      }else{
        _opacity = 0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //animeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Opacity(
          opacity: _opacity,
          child: Stack(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    child: Image(
                      fit: BoxFit.cover,
                      image: Image.network(widget.anime.attributes.posterImage.original).image,
                    )),
              ),
              Center(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: _sigma, sigmaY: _sigma),
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                        child: Container()),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class AnimeDetailPage extends StatefulWidget {
  @Deprecated("use animeId instead")
  final Anime anime;
  final String tag;
  String animeId;
  LibraryEntry libraryEntry;
  bool isFromLibrary;

  AnimeDetailPage(
      {@Deprecated("user animeId instead") this.anime, @required this.tag, @required this.animeId, this.isFromLibrary = false, this.libraryEntry})
      : assert((isFromLibrary && libraryEntry != null) || (!isFromLibrary)),
        assert(animeId != null);

  @override
  State<StatefulWidget> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final sliverAppBarKey = GlobalKey();
  final scrollController = ScrollController();
  final animeBloc = AnimeBloc();
  final postBloc = PostBloc();
  Anime anime;
  String genresLink;
  bool showRemoveFB = false;
  bool initialized = false;

  @override
  void initState() {
    super.initState();

    animeBloc.fetchAnimeById(widget.animeId);
    //animeBloc.fetchEpisodesByAnimeId(widget.animeId);
    animeBloc.fetchStreamingLinksByAnimeId(widget.animeId);
    animeBloc.fetchCategoriesByAnimeId(widget.animeId);
    showRemoveFB = widget.animeId != null;
    postBloc.fetchPostsByAnimeId(widget.animeId);
  }

  @override
  void dispose() {
    super.dispose();
    animeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: animeBloc.anime,
        builder: (_, AsyncSnapshot<Anime> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            anime = asyncSnapshot.data;
            genresLink = anime.relationships['genres'].links.related.startsWith("http")
                ? anime.relationships['genres'].links.related
                : 'https://kitsu.io/api/edge' + anime.relationships['genres'].links.related;
            return Stack(
              children: <Widget>[
                //this container is for background
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.redAccent,
                ),
                BackdropPoster(anime, scrollController),
                CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(
                          height: 0,
                        ),
                        _Header(anime, widget.tag),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: double.infinity,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                              child: Text(
                                "Watch trailer",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                launchYoutubeURL(anime.attributes.youtubeVideoId);
                              },
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Container(
                              height: 100,
                              child: buildStreamerRow(),
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: StreamBuilder(
                              stream: animeBloc.categories,
                              builder: (_, AsyncSnapshot<List<Category>> snapshot){
                                if(snapshot.hasData){
                                  return _ChipsRow(categories: snapshot.data);
                                }else if(snapshot.hasError){
                                  return Center(
                                    child: Text(snapshot.error),
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: _EpisodesRow(animeId: anime.id, fallbackLink: anime.attributes.posterImage.medium,),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: double.infinity,
                            //height: 300,
                            child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                                elevation: 2,
                                color: Colors.white,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        buildRow("Status", anime.attributes.status),
                                        Divider(),
                                        buildRow("Average Rating", anime.attributes.averageRating),
                                        Divider(),
                                        buildRow("Show Type", anime.attributes.showType),
                                        Divider(),
                                        buildRow("Start Date", anime.attributes.startDate),
                                        Divider(),
                                        buildRow("End Date", anime.attributes.endDate),
                                      ],
                                    ))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: double.infinity,
                            child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                                elevation: 2,
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: anime.attributes.synopsis.isEmpty
                                      ? Center(
                                          child: Text(
                                            '¯\\_(ツ)_/¯\nNothing here',
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Text(anime.attributes.synopsis),
                                )),
                          ),
                        ),
                        FutureBuilder(
                          future: getRequestAsJson('https://kitsu.io/api/edge/media-reactions?filter[animeId]=${anime.id}'),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              var mediaReactions = MediaReactions.fromJson(snapshot.data);
                              return ReactionsSection(mediaReactions, anime.id);
                            } else {
                              return Center(
                                child: LinearProgressIndicator(),
                              );
                            }
                          },
                        ),
                        //buildRelatedSection(),
                        IntrinsicHeight(
                          child: StreamBuilder(
                            stream: postBloc.posts,
                            builder: (_, AsyncSnapshot<List<PostModel.Post>> snapshot){
                              if(snapshot.hasData){
                                var posts = snapshot.data;
                                return Column(
                                  children: posts.map((post)=>PostCard(post:post, keepPadding: true,padding: 8,)).toList(),
                                );
                              }else{
                                return Container();
                              }
                            },
                          )
                        ),
                        Container(
                          height: 80,
                        )
                      ]),
                    ),
                  ],
                ),
                BackIconButton(() => Navigator.pop(context), scrollController),
              ],
            );
          } else if (asyncSnapshot.hasError) {
            return Text(asyncSnapshot.error);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        child: widget.isFromLibrary
            ? FloatingActionButton.extended(
                heroTag: "fab1",
                backgroundColor: Colors.grey,
                icon: Icon(Icons.clear),
                label: Text(
                  'REMOVE FROM LIBRARY',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: handleRemovePressed,
              )
            : FloatingActionButton.extended(
                heroTag: "fab2",
                icon: Icon(Icons.add),
                label: Text(
                  'ADD TO MY LIBRARY',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: handleAddPressed,
              ),
      ),
    );
  }

  Widget buildStreamerRow() {
    return StreamBuilder(
      stream: animeBloc.streamingLinks,
      builder: (_, AsyncSnapshot<List<StreamingLink>> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          var streamingLinks = asyncSnapshot.data;
          return streamingLinks.isEmpty?Container(child: Center(child: Text('No streamer offers this one.')),):ListView(
            scrollDirection: Axis.horizontal,
            children: streamingLinks
                .map((link) => StreamerCard(siteName: link.streamer.attributes.siteName, onTap: () => launchURL(link.attributes.url)))
                .toList(),
          );
        } else if (asyncSnapshot.hasError)
          return Center(child: Text(asyncSnapshot.error));
        else
          return Center(child: LinearProgressIndicator());
      },
    );
  }

  ///build rows for the anime info part
  Widget buildRow(String title, String info) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
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

  @Deprecated('Genres is deprecated according to Kitsu')
  Widget buildRelatedSection() {
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
                child: Container(
                  height: 200,
                  width: 200,
                  child: FutureBuilder(
                      future: getRequestAsJson(genresLink),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          var genresData = GenresData.fromJson(snapshot.data);
                          var genres = genresData.genres;
                          genres.removeWhere((genre) => genre.id == anime.id);

                          return genres.isEmpty
                              ? Center(
                                  child: Text(
                                  '¯\\_(ツ)_/¯\nNo recommendations',
                                  textAlign: TextAlign.center,
                                ))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: buildRelatedSectionChildren(genres),
                                  ),
                                );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ))),
      ),
    );
  }

  @Deprecated('Genres is deprecated according to Kitsu')
  List<Widget> buildRelatedSectionChildren(List<Genres> genres) {
    return genres.map((genres) {
      return FutureBuilder(
        future: getRequestAsJson('https://kitsu.io/api/edge/anime/${genres.id}'),
        builder: (_, snap) {
          if (snap.hasData) {
            var anime = AnimeData.fromJson(snap.data).anime;

            return Padding(
                padding: EdgeInsets.all(8),
                child: Hero(
                    tag: anime.id,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimeBlocProvider(
                                      child: AnimeDetailPage(
                                    tag: anime.id,
                                    animeId: anime.id,
                                  )),
                            ));
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: Center(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: anime.attributes.posterImage.small,
                            ),
                          ),
                        ),
                      ),
                    )));
          } else {
            return Container();
          }
        },
      );
    }).toList();
  }

  void handleAddPressed() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 0),
                    child: ListTile(
                      leading: Icon(
                        Icons.done,
                        color: Colors.black87,
                      ),
                      title: Text(
                        'COMPLETED',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        handleAdd(Status.COMPLETED);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                    child: ListTile(
                      leading: Icon(
                        Icons.fast_forward,
                        color: Colors.black87,
                      ),
                      title: Text(
                        'CURRENT',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        handleAdd(Status.CURRENT);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                    child: ListTile(
                      leading: Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.black87,
                      ),
                      title: Text(
                        'DROPPED',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        handleAdd(Status.DROPPED);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                    child: ListTile(
                      leading: Icon(
                        Icons.all_inclusive,
                        color: Colors.black87,
                      ),
                      title: Text(
                        'ON HOLD',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        handleAdd(Status.ONHOLD);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                    child: ListTile(
                      leading: Icon(
                        Icons.beenhere,
                        color: Colors.black87,
                      ),
                      title: Text(
                        'PLANNED',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        handleAdd(Status.PLANNED);
                      },
                    )),
              ],
            ),
          );
        });
  }

  void handleAdd(Status status) {
    libraryEntriesBloc.addLibraryEntry(anime.id, status);
    setState(() {
      widget.isFromLibrary = true;
    });
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 4),
          child: Icon(Icons.done),
        ),
        Text('Added successfully')
      ],
    )));
  }

  void handleRemovePressed() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
              height: 160,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Container(
                        width: double.infinity,
                        color: Colors.red[900],
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Are you sure?',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                      flex: 4,
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'NO',
                              style: TextStyle(
                                color: Colors.red[900],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'YES, DELETE',
                              style: TextStyle(
                                color: Colors.red[900],
                              ),
                            ),
                            onPressed: () {
                              var url = "https://kitsu.io/api/edge/library-entries/${widget.libraryEntry.id}";
                              var deleteRequest = Request('DELETE', Uri.parse(url));
                              var client = Client();
                              deleteRequest.headers["Authorization"] = "Bearer aebc1c3fbe4f4af89558a23753ec13d1a5b05518e3e3ef5bd2b89ced0e307826";
                              deleteRequest.headers["Content-Type"] = "application/vnd.api+json";
                              client
                                  .send(deleteRequest)
                                  .then((res) => res.stream.bytesToString().then((val) => print(val.toString())))
                                  .whenComplete(() {
                                libraryEntriesBloc.fetchLibraryEntriesData();
                              });

                              ///TODO: delete using just ID
                              scaffoldKey.currentState.removeCurrentSnackBar();
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(Icons.done),
                                  ),
                                  Text('Deleted successfully')
                                ],
                              )));
                              Navigator.pop(context);
                              setState(() {
                                widget.isFromLibrary = false;
                              });
                            },
                          ),
                        ],
                      ))
                ],
              ));
        });
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchYoutubeURL(String videoId) async {
    String url = 'http://www.youtube.com/watch?v=' + videoId;
    if (await canLaunch(url)) {
      await launch(url, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class _Header extends StatelessWidget {
  _Header(this.anime, this.tag);
  final Anime anime;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final posterImage = Hero(
      tag: this.tag,
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Material(
            elevation: 12,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: anime.attributes.posterImage.small,
            ),
          )),
    );

    return Stack(
      children: [
        // Transparent container that makes the space for the backdrop photo.
        Container(
          height: 300.0,
          margin: const EdgeInsets.only(bottom: 132.0),
        ),
        // Makes for the white background in poster and event information.
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            color: Colors.redAccent,
            height: 132.0,
          ),
        ),
        Positioned(
          left: 10.0,
          bottom: 0.0,
          height: 200,
          child: posterImage,
        ),
        Positioned(
          top: 238.0,
          left: 156.0,
          right: 16.0,
          child: Text(
            anime.attributes.titles.jaJp,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Noto', fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
            top: 310.0,
            left: 156.0,
            right: 16.0,
            child: Column(
              children: <Widget>[
                Text(
                  anime.attributes.canonicalTitle,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Noto', fontWeight: FontWeight.bold),
                ),
                anime.attributes.episodeCount == null
                    ? Container()
                    : Text(
                        "${anime.attributes.episodeCount} episodes",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontFamily: 'Noto'),
                      ),
              ],
            )),
      ],
    );
  }
}

class _ChipsRow extends StatelessWidget {
  final List<Category> categories;

  _ChipsRow({@required this.categories});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: buildChildren(context, categories),
      ),
    );
  }

  List<Widget> buildChildren(BuildContext context, List<Category> categories) {
    var children = List<Widget>();
    children.add(SizedBox(width: 8));
    children.addAll(categories.map((category) {
      return Padding(
        padding: EdgeInsets.only(right: 8),
        child: ActionChip(
            label: Text(category.attributes.title),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnimeGridViewPage(
                        title: category.attributes.title,
                        categoryId: category.id,
                      ),
                ))),
      );
    }));
    return children;
  }
}

class _EpisodesRow extends StatefulWidget{
  final String animeId;
  final String fallbackLink;

  _EpisodesRow({@required this.animeId, @required this.fallbackLink});

  @override
  State<StatefulWidget> createState() =>_EpisodesRowState();
}

class _EpisodesRowState extends State<_EpisodesRow>{
  final animeBloc = AnimeBloc();
  final scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        animeBloc.fetchEpisodesByAnimeId(widget.animeId);
      }
    });
    animeBloc.fetchEpisodesByAnimeId(widget.animeId);
  }

  @override
  void dispose() {
    super.dispose();
    animeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: animeBloc.episodes,
      builder: (_, AsyncSnapshot<List<Episode>> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          var episodes = asyncSnapshot.data;
          return SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: buildChildren(episodes),
            ),
          );
        } else if (asyncSnapshot.hasError) {
          return Center(child: Text(asyncSnapshot.error));
        } else {
          return Center(child: LinearProgressIndicator());
        }
      },
    );
  }

  List<Widget> buildChildren(List<Episode> episodes) {
    double borderRaius = 6;
    int episodeIndex = 0;
    var children = List<Widget>();
    children.add(SizedBox(width: 8));
    children.addAll(episodes.map((episode) {
      episodeIndex++;
      return Padding(
        padding: EdgeInsets.only(right: 8),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRaius))),
          child: Container(
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRaius))),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(borderRaius)),
                  child: FadeInImage.memoryNetwork(
                      fit: BoxFit.fitHeight,
                      placeholder: kTransparentImage,
                      image: episode.attributes.thumbnail == null?widget.fallbackLink:episode.attributes.thumbnail.original
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(episodeIndex.toString(),style: TextStyle(color: Colors.white70, fontSize: 48),),
                )
              ],
            )
          ),
        )
      );
    }));
    return children;
  }
}
