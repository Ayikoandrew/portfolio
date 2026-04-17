import '../entities/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticles();
  Future<Article?> getArticleById(String id);
}
