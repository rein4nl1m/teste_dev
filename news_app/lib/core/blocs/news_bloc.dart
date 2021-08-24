import 'package:flutter/foundation.dart';
import 'package:news_app/data/model/news_model.dart';
import 'package:news_app/data/repositories/news_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc extends ChangeNotifier {
  var newsRepo = NewsRepositoryImpl();

  var newsList = BehaviorSubject<List<NewsModel>>();
  Stream<List<NewsModel>> get streamNewsList => newsList.stream;

  void fetchAllNews() async {
    var result = await newsRepo.fetchAll();

    if (newsList.valueOrNull != null && newsList.valueOrNull!.isNotEmpty)
      newsList.value.clear();

    if (result != null) {
      newsList.add(
        result.map((item) => item).toList(),
      );
    }
  }

  void searchNews(String keyword) async {
    var result = await newsRepo.searchNews(keyword);

    if (newsList.valueOrNull != null && newsList.valueOrNull!.isNotEmpty)
      newsList.value.clear();

    if (result != null) {
      newsList.add(
        result.map((item) => item).toList(),
      );
    }
  }

  Future<int?> addNews(NewsModel news) async {
    return await newsRepo.insert(news: news);
  }

  Future<int?> editNews(NewsModel news) async {
    return await newsRepo.update(news: news);
  }

  Future<int?> removeNews(int? id) async {
    if (id == null) return null;
    return await newsRepo.delete(id: id);
  }
}
