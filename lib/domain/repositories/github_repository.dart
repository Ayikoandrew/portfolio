import '../entities/github_repo.dart';

abstract class GithubRepository {
  Future<List<GithubRepo>> getRepositories();
}
