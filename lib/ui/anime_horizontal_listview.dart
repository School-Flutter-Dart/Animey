import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:animey/anime_detail_page.dart';
import 'package:animey/blocs/anime_bloc_provider.dart';
import 'package:animey/models/anime.dart';

class AnimeHorizantalListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AnimeBlocProvider.of(context).animes,
      builder: (_, AsyncSnapshot<List<Anime>> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return buildSection(context,asyncSnapshot.data);
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  Widget buildSection(BuildContext context,List<Anime> animes) {
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
                    child: animes.isEmpty
                        ? Center(
                            child: Text(
                            '¯\\_(ツ)_/¯\nNo recommendations',
                            textAlign: TextAlign.center,
                          ))
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: buildSectionChildren(context,animes),
                            ),
                          )))),
      ),
    );
  }

  List<Widget> buildSectionChildren(BuildContext context,List<Anime> animes) {
    return animes.map((anime) {
      return Padding(
          padding: EdgeInsets.all(8),
          child: Hero(
              tag: "trending"+anime.id, //to avoid hero conflict
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
                        image: anime.attributes.posterImage.medium,
                      ),
                    ),
                  ),
                ),
              )));
    }).toList();
  }
}
