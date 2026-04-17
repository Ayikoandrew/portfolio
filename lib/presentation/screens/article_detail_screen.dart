import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../providers/article_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/block_content_renderer.dart';
import '../widgets/markdown_renderer.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final String articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleByIdProvider(articleId));
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      body: Stack(
        children: [
          articleAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 16),
                  Text('Article not found', style: theme.textTheme.titleMedium),
                ],
              ),
            ),
            data: (article) {
              if (article == null) {
                return Center(
                  child: Text(
                    'Article not found',
                    style: theme.textTheme.titleMedium,
                  ),
                );
              }

              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 740),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 40,
                        vertical: 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Space for nav bar
                          const SizedBox(height: 100),

                          // Back link
                          TextButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back, size: 18),
                            label: const Text('All articles'),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.textTheme.bodySmall?.color,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: article.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tag,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // Title
                          SelectableText(
                            article.title,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontSize: isMobile ? 28 : 38,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Meta row
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                                child: Text(
                                  article.author
                                      .split(' ')
                                      .map((w) => w[0])
                                      .take(2)
                                      .join(),
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.author,
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  Text(
                                    '${_formatDate(article.date)}  ·  ${article.readTimeMinutes} min read',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Divider(color: theme.dividerColor),
                          const SizedBox(height: 12),

                          // Article content
                          if (article.hasRichContent)
                            BlockContentRenderer(blocks: article.contentBlocks!)
                          else
                            MarkdownRenderer(data: article.content),

                          const SizedBox(height: 40),
                          Divider(color: theme.dividerColor),
                          const SizedBox(height: 24),

                          // Footer
                          Center(
                            child: TextButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back, size: 18),
                              label: const Text('Back to all articles'),
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Nav bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _DetailNavBar(ref: ref, isDark: isDark),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month]} ${date.day}, ${date.year}';
  }
}

class _DetailNavBar extends StatelessWidget {
  final WidgetRef ref;
  final bool isDark;
  const _DetailNavBar({required this.ref, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      color: theme.scaffoldBackgroundColor.withValues(alpha: 0.92),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: 14,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          ),
          const SizedBox(width: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: AppColors.gradientColors,
            ).createShader(bounds),
            child: Text(
              'AA',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 22,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
      ),
    );
  }
}
