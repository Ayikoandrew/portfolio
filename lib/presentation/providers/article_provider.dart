import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

final articleRepositoryProvider = Provider<ArticleRepository>(
  (ref) => ArticleRepositoryImpl(),
);

final articlesProvider = FutureProvider<List<Article>>((ref) async {
  final repository = ref.read(articleRepositoryProvider);
  return repository.getArticles();
});

final articleByIdProvider = FutureProvider.family<Article?, String>((
  ref,
  id,
) async {
  final repository = ref.read(articleRepositoryProvider);
  return repository.getArticleById(id);
});
