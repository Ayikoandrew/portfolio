import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/github_repo.dart';

class ProjectCard extends StatefulWidget {
  final GithubRepo repo;

  const ProjectCard({super.key, required this.repo});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
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
        child: Card(
          color: _hovered
              ? (isDark
                    ? AppColors.darkCard.withValues(alpha: 0.9)
                    : AppColors.lightCard)
              : theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _hovered
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : theme.dividerColor,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _launchUrl(widget.repo.htmlUrl),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.repo.name,
                          style: theme.textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        size: 18,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Expanded(
                    child: Text(
                      widget.repo.description ?? 'No description',
                      style: theme.textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Footer
                  Row(
                    children: [
                      if (widget.repo.language != null) ...[
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _languageColor(widget.repo.language!),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.repo.language!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Icon(
                        Icons.star_border,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.repo.stars}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      if (widget.repo.forks > 0) ...[
                        const SizedBox(width: 16),
                        Icon(
                          Icons.call_split,
                          size: 16,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.repo.forks}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _languageColor(String language) {
    return switch (language.toLowerCase()) {
      'python' => const Color(0xFF3572A5),
      'dart' => const Color(0xFF00B4AB),
      'javascript' => const Color(0xFFF1E05A),
      'typescript' => const Color(0xFF3178C6),
      'c++' => const Color(0xFFF34B7D),
      'java' => const Color(0xFFB07219),
      'html' => const Color(0xFFE34C26),
      'css' => const Color(0xFF563D7C),
      'jupyter notebook' => const Color(0xFFDA5B0B),
      _ => AppColors.primary,
    };
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
