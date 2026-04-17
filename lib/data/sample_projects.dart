import '../domain/entities/github_repo.dart';

/// Sample projects displayed in the portfolio.
/// Replace or extend these with your own projects.
const List<GithubRepo> sampleProjects = [
  GithubRepo(
    name: 'farm-rl-agent',
    description:
        'Reinforcement learning agent that learns optimal irrigation and fertilization strategies using PPO in simulated farm environments.',
    htmlUrl: 'https://github.com/Ayikoandrew/farm-rl-agent',
    stars: 42,
    forks: 8,
    language: 'Python',
    topics: ['reinforcement-learning', 'agriculture', 'ppo', 'gymnasium'],
  ),
  GithubRepo(
    name: 'rainfall-tft',
    description:
        'Temporal Fusion Transformer for dekadal rainfall forecasting in East Africa, trained on CHIRPS satellite and ERA5 reanalysis data.',
    htmlUrl: 'https://github.com/Ayikoandrew/rainfall-tft',
    stars: 35,
    forks: 12,
    language: 'Python',
    topics: ['deep-learning', 'climate', 'time-series', 'pytorch'],
  ),
  GithubRepo(
    name: 'crop-health-cv',
    description:
        'EfficientNet-based crop health classifier for multispectral drone imagery with DINO self-supervised pre-training.',
    htmlUrl: 'https://github.com/Ayikoandrew/crop-health-cv',
    stars: 28,
    forks: 5,
    language: 'Python',
    topics: ['computer-vision', 'drones', 'agriculture', 'pytorch'],
  ),
  GithubRepo(
    name: 'portfolio',
    description:
        'Personal portfolio website built with Flutter Web featuring responsive design, dark mode, and rich article rendering.',
    htmlUrl: 'https://github.com/Ayikoandrew/portfolio',
    stars: 15,
    forks: 3,
    language: 'Dart',
    topics: ['flutter', 'portfolio', 'web', 'dart'],
  ),
  GithubRepo(
    name: 'agri-chatbot',
    description:
        'LLM-powered chatbot providing planting advisories and pest identification for smallholder farmers in Uganda.',
    htmlUrl: 'https://github.com/Ayikoandrew/agri-chatbot',
    stars: 22,
    forks: 6,
    language: 'Python',
    topics: ['llm', 'chatbot', 'agriculture', 'langchain'],
  ),
  GithubRepo(
    name: 'ndvi-pipeline',
    description:
        'Automated NDVI computation and anomaly detection pipeline for satellite imagery using Google Earth Engine and Python.',
    htmlUrl: 'https://github.com/Ayikoandrew/ndvi-pipeline',
    stars: 18,
    forks: 4,
    language: 'Python',
    topics: ['remote-sensing', 'gee', 'ndvi', 'geospatial'],
  ),
];
