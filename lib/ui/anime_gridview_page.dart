import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:animey/models/anime.dart';
import 'package:animey/blocs/anime_bloc.dart';
import 'package:animey/anime_detail_page.dart';

class AnimeGridViewPage extends StatefulWidget {
  final String title;
  final String categoryId;
  final String streamerId;
  final String animesLink;

  AnimeGridViewPage({@required this.title, this.categoryId, this.streamerId,this.animesLink}) : assert(categoryId != null || streamerId !=null||animesLink != null);

  @override
  State<StatefulWidget> createState() => _AnimeGridViewPageState();
}

class _AnimeGridViewPageState extends State<AnimeGridViewPage> {
  final animeBloc = AnimeBloc();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent)
        animeBloc.fetchMoreAnimes();
    });

    if (widget.categoryId != null) {
      animeBloc.fetchAnimesByCategoryId(widget.categoryId, withOnlyPosterImage: true);
    } else if(widget.streamerId != null){
      animeBloc.fetchAnimesByStreamerId(widget.streamerId);
    }else if (widget.animesLink != null) {
      animeBloc.fetchAnimes(widget.animesLink, withOnlyPosterImage: true);
    }
  }

  @override
  void dispose() {
    animeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: animeBloc.animes,
        builder: (_, AsyncSnapshot<List<Anime>> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            var animes = asyncSnapshot.data;

            return GridView(
                controller: scrollController,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0, childAspectRatio: 0.7),
                children: buildChildren(animes),
              );
          } else if (asyncSnapshot.hasError) {
            print(asyncSnapshot.error);
            return Center(child: Text(asyncSnapshot.error));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<Widget> buildChildren(List<Anime> animes) {
    return animes.map((anime) {
      return Hero(
        tag: "gridview"+anime.id,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AnimeDetailPage(
                        animeId: anime.id,
                        tag: "gridview"+anime.id,
                      ))),
          child: Container(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: anime.attributes.posterImage.medium,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }).toList();
  }
}
