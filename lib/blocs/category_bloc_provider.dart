import 'package:flutter/material.dart';
import 'category_bloc.dart';

class CategoryBlocProvider extends InheritedWidget {
  final CategoryBloc categoryBloc;

  CategoryBlocProvider({Key key, Widget child, String animeId})
      : categoryBloc = CategoryBloc(),
        super(key: key, child: child){
    if(animeId != null) {
      categoryBloc.fetchCategoriesByAnimeId(animeId);
    }
  }

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static CategoryBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CategoryBlocProvider)
    as CategoryBlocProvider)
        .categoryBloc;
  }
}