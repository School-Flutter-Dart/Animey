import 'package:flutter/material.dart';
import 'anime_bloc.dart';
import 'package:animey/models/library_entries.dart';

class AnimeBlocProvider extends InheritedWidget {
  final AnimeBloc animeBloc;

  AnimeBlocProvider({Key key, Widget child, String link, String categoryId, bool withOnlyPosterImage = false, LibraryEntry entryForBrief})
      : animeBloc = AnimeBloc(),
        super(key: key, child: child){
    if(link != null){
      animeBloc.fetchAnimes(link, withOnlyPosterImage: withOnlyPosterImage);
    }else if(entryForBrief != null){
      animeBloc.fetchBriefAnime(entryForBrief);
    }else if(categoryId != null){
      animeBloc.fetchAnimesByCategoryId(categoryId,withOnlyPosterImage: withOnlyPosterImage);
    }
  }

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static AnimeBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AnimeBlocProvider)
    as AnimeBlocProvider)
        .animeBloc;
  }
}