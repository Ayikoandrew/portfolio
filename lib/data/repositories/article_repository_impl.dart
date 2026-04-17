import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../sample_articles.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  @override
  Future<List<Article>> getArticles() async {
    // Return sample articles sorted by date (newest first).
    return List.of(sampleArticles)..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<Article?> getArticleById(String id) async {
    final articles = await getArticles();
    try {
      return articles.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
