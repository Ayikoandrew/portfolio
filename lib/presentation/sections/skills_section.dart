import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../widgets/animate_on_visible.dart';
import '../widgets/section_title.dart';
import '../widgets/skill_chip.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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
                  title: 'Skills & Technologies',
                  subtitle: 'Tools and technologies I work with.',
                ),
                for (
                  var i = 0;
                  i < AppConstants.skillCategories.length;
                  i++
                ) ...[
                  if (i > 0) const SizedBox(height: 32),
                  AnimateOnVisible(
                    delay: Duration(milliseconds: 100 * i),
                    child: _SkillGroup(
                      category: AppConstants.skillCategories[i],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkillGroup extends StatelessWidget {
  final SkillCategory category;
  const _SkillGroup({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.gradientColors,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(category.title, style: theme.textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: category.skills
              .map((skill) => SkillChip(label: skill))
              .toList(),
        ),
      ],
    );
  }
}
