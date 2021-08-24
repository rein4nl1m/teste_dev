import 'package:news_app/data/model/news_model.dart';

abstract class NewsRepository {
  Future<int?> insert({required NewsModel news});

  Future<int?> update({required NewsModel news});

  Future<int?> delete({required int id});

  Future<List<NewsModel>?> fetchAll();

  Future<List<NewsModel>?> searchNews(String keyword);
}
