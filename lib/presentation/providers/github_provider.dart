import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/github_repository_impl.dart';
import '../../domain/entities/github_repo.dart';
import '../../domain/repositories/github_repository.dart';

final githubRepositoryProvider = Provider<GithubRepository>(
  (ref) => GithubRepositoryImpl(),
);

final githubReposProvider = FutureProvider<List<GithubRepo>>((ref) async {
  final repository = ref.read(githubRepositoryProvider);
  return repository.getRepositories();
});
