import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scroll_provider.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/research_section.dart';
import '../sections/skills_section.dart';
import '../widgets/nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionKeys = ref.watch(sectionKeysProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                _keyed(sectionKeys['Home'], const HeroSection()),
                _keyed(sectionKeys['About'], const AboutSection()),
                _keyed(sectionKeys['Research'], const ResearchSection()),
                _keyed(sectionKeys['Projects'], const ProjectsSection()),
                _keyed(sectionKeys['Skills'], const SkillsSection()),
                _keyed(sectionKeys['Contact'], const ContactSection()),
              ],
            ),
          ),

          // Fixed nav bar
          const Positioned(top: 0, left: 0, right: 0, child: NavBar()),
        ],
      ),
    );
  }

  Widget _keyed(GlobalKey? key, Widget child) {
    return KeyedSubtree(key: key ?? GlobalKey(), child: child);
  }
}
