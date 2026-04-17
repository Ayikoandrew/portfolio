import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/responsive.dart';
import '../providers/github_provider.dart';
import '../widgets/animate_on_visible.dart';
import '../widgets/project_card.dart';
import '../widgets/section_title.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(githubReposProvider);

    return AnimateOnVisible(
      child: Padding(
        padding: Responsive.sectionPadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.contentMaxWidth(context),
            ),
            child: Column(
              children: [
                const SectionTitle(
                  title: 'Projects',
                  subtitle:
                      'A selection of my open-source and research projects.',
                ),
                reposAsync.when(
                  loading: () => _buildLoading(context),
                  error: (err, _) => _buildError(context, err, ref),
                  data: (repos) {
                    if (repos.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('No repositories found.'),
                        ),
                      );
                    }

                    final crossAxisCount = Responsive.gridCrossAxisCount(
                      context,
                    );
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: crossAxisCount == 1 ? 2.0 : 1.4,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: repos.length,
                      itemBuilder: (context, i) => AnimateOnVisible(
                        delay: Duration(milliseconds: 80 * i),
                        child: ProjectCard(repo: repos[i]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final crossAxisCount = Responsive.gridCrossAxisCount(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: crossAxisCount == 1 ? 2.0 : 1.4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: 6,
      itemBuilder: (context, _) => const _ShimmerCard(),
    );
  }

  Widget _buildError(BuildContext context, Object err, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off,
            size: 48,
            color: theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(height: 16),
          Text(
            'Could not load repositories',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            err.toString(),
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => ref.invalidate(githubReposProvider),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBar(width: 140, height: 18, isDark: isDark),
                const SizedBox(height: 16),
                _shimmerBar(width: double.infinity, height: 14, isDark: isDark),
                const SizedBox(height: 8),
                _shimmerBar(width: 200, height: 14, isDark: isDark),
                const Spacer(),
                _shimmerBar(width: 100, height: 12, isDark: isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerBar({
    required double width,
    required double height,
    required bool isDark,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
