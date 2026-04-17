import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../widgets/animate_on_visible.dart';
import '../widgets/section_title.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

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
                  title: 'About Me',
                  subtitle: 'Background, education, and what drives me.',
                ),
                if (isMobile)
                  const _AboutContent()
                else
                  const IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _AboutContent()),
                        SizedBox(width: 48),
                        Expanded(flex: 2, child: _InterestsGrid()),
                      ],
                    ),
                  ),
                if (isMobile) ...[
                  const SizedBox(height: 40),
                  const _InterestsGrid(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Education badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.school, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'MSc Artificial Intelligence — Year 1, Semester 2',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text(AppConstants.aboutText, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

class _InterestsGrid extends StatelessWidget {
  const _InterestsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < AppConstants.interests.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          AnimateOnVisible(
            delay: Duration(milliseconds: 100 * i),
            child: _InterestCard(item: AppConstants.interests[i]),
          ),
        ],
      ],
    );
  }
}

class _InterestCard extends StatefulWidget {
  final InterestItem item;
  const _InterestCard({required this.item});

  @override
  State<_InterestCard> createState() => _InterestCardState();
}

class _InterestCardState extends State<_InterestCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.primary.withValues(alpha: 0.08)
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withValues(alpha: 0.3)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.item.icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    widget.item.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
