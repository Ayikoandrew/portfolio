class GithubRepo {
  final String name;
  final String? description;
  final String htmlUrl;
  final int stars;
  final int forks;
  final String? language;
  final List<String> topics;

  const GithubRepo({
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.stars,
    required this.forks,
    required this.language,
    required this.topics,
  });
}
