import '../../domain/entities/github_repo.dart';
import '../../domain/repositories/github_repository.dart';
import '../sample_projects.dart';

class GithubRepositoryImpl implements GithubRepository {
  @override
  Future<List<GithubRepo>> getRepositories() async {
    // Return sample projects — replace with API call or database if needed.
    return sampleProjects;
  }
}
