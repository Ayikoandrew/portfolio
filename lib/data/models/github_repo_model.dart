import '../../domain/entities/github_repo.dart';

class GithubRepoModel extends GithubRepo {
  const GithubRepoModel({
    required super.name,
    required super.description,
    required super.htmlUrl,
    required super.stars,
    required super.forks,
    required super.language,
    required super.topics,
  });

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) {
    return GithubRepoModel(
      name: json['name'] as String,
      description: json['description'] as String?,
      htmlUrl: json['html_url'] as String,
      stars: json['stargazers_count'] as int? ?? 0,
      forks: json['forks_count'] as int? ?? 0,
      language: json['language'] as String?,
      topics:
          (json['topics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
