
import 'package:rxdart/rxdart.dart';
import 'package:animey/resources/repository.dart';
import 'package:animey/models/category.dart';

class CategoryBloc{
  final _repository = Repository();
  final _categoriesFetcher = BehaviorSubject<List<Category>>();

   Observable<List<Category>> get categories => _categoriesFetcher.stream;

  fetchCategoriesByAnimeId(String animeId) async{
    List<Category> categories = await _repository.fetchCategoriesByAnimeId(animeId);
    _categoriesFetcher.sink.add(categories);
  }

  dispose(){
    _categoriesFetcher.close();
  }

}