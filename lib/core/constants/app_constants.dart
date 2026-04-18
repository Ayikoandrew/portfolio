import 'package:flutter/material.dart';

abstract final class AppConstants {
  static const githubUsername = 'Ayikoandrew';
  static const githubUrl = 'https://github.com/Ayikoandrew';
  static const linkedInUrl =
      'https://www.linkedin.com/in/ayiko-andrew-aa9885239';

  static const name = 'Ayiko Andrew';
  static const tagline = 'AI Researcher & Developer';
  static const heroSubtitle =
      'ML Engineer & MSc AI candidate - I explore language, vision, and '
      'intelligent systems, then build them into products that create real impact. Also I love food from its preparation to presentation.';

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
      'I specialize in applying machine learning to high-impact domains - '
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
      icon: Icons.agriculture,
      title: 'AI-Driven Agricultural Decision Support',
      description:
          'Developing an integrated ML pipeline that combines time series deep learning '
          'for rainfall prediction with reinforcement learning for sequential crop decisions - '
          'the agent monitors soil moisture and crop stress to recommend what to plant '
          'as rainfall patterns emerge, helping smallholder farmers act at the right '
          'moment with the right crop.',
      tags: [
        'Deep Learning',
        'Reinforcement Learning',
        'Time Series',
        'AgriTech',
      ],
    ),

    ResearchItem(
      icon: Icons.coronavirus,
      title: 'Ensemble Methods for Real-Time Disease Outbreak Prediction',
      description:
          'Investigating the theoretical and empirical computational complexity of '
          'Random Forest and LightGBM for disease outbreak prediction in resource-limited '
          'settings - using malaria in Uganda as the primary case study, benchmarked on '
          'standard CPU hardware to ensure feasibility without specialized infrastructure.',
      tags: [
        'Ensemble Learning',
        'LightGBM',
        'Public Health',
        'Complexity Analysis',
      ],
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
        'Recommender Systems',
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
