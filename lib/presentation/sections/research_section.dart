import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../widgets/animate_on_visible.dart';
import '../widgets/section_title.dart';

class ResearchSection extends StatelessWidget {
  const ResearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimateOnVisible(
      child: Container(
        width: double.infinity,
        color: isDark ? AppColors.darkSurface : AppColors.lightCard,
        padding: Responsive.sectionPadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.contentMaxWidth(context),
            ),
            child: Column(
              children: [
                const SectionTitle(
                  title: 'Research',
                  subtitle:
                      'Current research at the intersection of AI and agriculture.',
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = Responsive.gridCrossAxisCount(
                      context,
                    );
                    if (crossAxisCount == 1) {
                      return Column(
                        children: [
                          for (
                            var i = 0;
                            i < AppConstants.researchItems.length;
                            i++
                          ) ...[
                            if (i > 0) const SizedBox(height: 16),
                            AnimateOnVisible(
                              delay: Duration(milliseconds: 120 * i),
                              child: _ResearchCard(
                                item: AppConstants.researchItems[i],
                              ),
                            ),
                          ],
                        ],
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: AppConstants.researchItems.length,
                      itemBuilder: (context, i) => AnimateOnVisible(
                        delay: Duration(milliseconds: 120 * i),
                        child: _ResearchCard(
                          item: AppConstants.researchItems[i],
                        ),
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
}

class _ResearchCard extends StatefulWidget {
  final ResearchItem item;
  const _ResearchCard({required this.item});

  @override
  State<_ResearchCard> createState() => _ResearchCardState();
}

class _ResearchCardState extends State<_ResearchCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: Offset(0, _hovered ? -0.02 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.4)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.item.icon,
                  color: AppColors.accent,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),

              Text(widget.item.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),

              Expanded(
                child: Text(
                  widget.item.description,
                  style: theme.textTheme.bodySmall,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 14),

              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: widget.item.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
