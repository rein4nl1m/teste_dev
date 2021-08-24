import '../../core/database/database_helper.dart';
import '../../data/model/news_model.dart';
import '../../domain/repositories/news_repository.dart';

class NewsRepositoryImpl extends NewsRepository {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<int?> delete({required int id}) async {
    try {
      return await dbHelper.delete(id);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<NewsModel>?> fetchAll() async {
    try {
      var result = await dbHelper.fetchAllNews();

      List<NewsModel> data = [];

      result.forEach((item) {
        data.add(NewsModel.fromMap(item));
      });

      return data;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<int?> insert({required NewsModel news}) async {
    try {
      var id = await dbHelper.insert(news.toMap());
      return id;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<int?> update({required NewsModel news}) async {
    try {
      var id = await dbHelper.update(news.toMap());
      return id;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<NewsModel>?> searchNews(String keyword) async {
    try {
      var result = await dbHelper.searchNews(keyword);

      List<NewsModel> data = [];

      result.forEach((item) {
        data.add(NewsModel.fromMap(item));
      });

      return data;
    } catch (e) {
      print(e);
    }
  }
}
