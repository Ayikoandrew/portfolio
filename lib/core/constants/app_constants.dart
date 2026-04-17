import 'package:flutter/material.dart';

abstract final class AppConstants {
  static const githubUsername = 'Ayikoandrew';
  static const githubUrl = 'https://github.com/Ayikoandrew';
  static const linkedInUrl =
      'https://www.linkedin.com/in/ayiko-andrew-aa9885239';

  static const name = 'Ayiko Andrew';
  static const tagline = 'AI Researcher & Developer';
  static const heroSubtitle =
      'MSc Artificial Intelligence student exploring the intersection '
      'of AI, agriculture, and computer vision to build impactful solutions.';

  static const navItems = [
    'Home',
    'About',
    'Research',
    'Projects',
    'Skills',
    'Articles',
    'Contact',
  ];

  static const aboutText =
      'MSc candidate in Artificial Intelligence with a background in Computer Science. '
      'I specialize in applying machine learning to high-impact domains — '
      'from climate-aware agricultural modeling to computer vision and NLP.\n\n'
      'Current focus: using reinforcement learning to build adaptive crop calendars '
      'that help farmers respond to shifting rainfall patterns. '
      'I\'m drawn to problems where the stakes are real.';

  static const interests = [
    InterestItem(
      icon: Icons.agriculture,
      title: 'AgriTech',
      description:
          'Applying AI to improve agricultural productivity and decision-making.',
    ),
    InterestItem(
      icon: Icons.visibility,
      title: 'Computer Vision',
      description:
          'Autonomous vehicles, object detection, and visual understanding.',
    ),
    InterestItem(
      icon: Icons.chat_bubble_outline,
      title: 'NLP',
      description:
          'Natural language processing for African languages and beyond.',
    ),
    InterestItem(
      icon: Icons.recommend,
      title: 'Recommender Systems',
      description:
          'Personalized recommendations using collaborative and content-based filtering.',
    ),
  ];

  static const researchItems = [
    ResearchItem(
      icon: Icons.water_drop,
      title: 'Rainfall Prediction',
      description:
          'Developing machine learning models to predict rainfall patterns, '
          'enabling farmers to make informed planting decisions and mitigate crop loss.',
      tags: ['Time Series', 'Deep Learning', 'Climate Data'],
    ),
    ResearchItem(
      icon: Icons.calendar_month,
      title: 'Crop Calendar Optimization',
      description:
          'Optimizing planting and harvesting schedules using data-driven approaches '
          'that account for weather variability and soil conditions.',
      tags: ['Optimization', 'Agricultural Planning', 'Data Science'],
    ),
    ResearchItem(
      icon: Icons.smart_toy,
      title: 'RL for Agricultural Decision-Making',
      description:
          'Applying reinforcement learning to sequential agricultural decisions — '
          'from irrigation scheduling to resource allocation.',
      tags: ['Reinforcement Learning', 'MDP', 'Policy Optimization'],
    ),
  ];

  static const skillCategories = [
    SkillCategory(
      title: 'Languages',
      skills: ['Python', 'Dart', 'Golang', 'SQL'],
    ),
    SkillCategory(
      title: 'AI / ML',
      skills: [
        'Deep Learning',
        'Computer Vision',
        'NLP',
        'Reinforcement Learning',
        'Time Series Analysis',
      ],
    ),
    SkillCategory(
      title: 'Frameworks & Libraries',
      skills: [
        'Flutter',
        'Keras',
        'PyTorch',
        'Scikit-learn',
        'FastAPI',
        'Pandas',
        'NumPy',
      ],
    ),
    SkillCategory(
      title: 'Tools & Platforms',
      skills: [
        'Git',
        'Docker',
        'Linux',
        'VS Code',
        'Jupyter',
        'Google Colab',
        'Firebase',
      ],
    ),
  ];
}

class InterestItem {
  final IconData icon;
  final String title;
  final String description;
  const InterestItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class ResearchItem {
  final IconData icon;
  final String title;
  final String description;
  final List<String> tags;
  const ResearchItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
  });
}

class SkillCategory {
  final String title;
  final List<String> skills;
  const SkillCategory({required this.title, required this.skills});
}
