import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Renders an image block with optional caption.
/// Supports both network URLs and local asset paths.
class ArticleImage extends StatelessWidget {
  final String src;
  final String? caption;

  const ArticleImage({super.key, required this.src, this.caption});

  bool get _isNetwork =>
      src.startsWith('http://') || src.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: _isNetwork ? _buildNetworkImage() : _buildAssetImage(),
              ),
            ),
          ),
          if (caption != null && caption!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              caption!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      src,
      width: double.infinity,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        final percent = progress.expectedTotalBytes != null
            ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
            : null;
        return Container(
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(value: percent),
        );
      },
      errorBuilder: (context, error, stack) => _buildErrorPlaceholder(context),
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      src,
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) => _buildErrorPlaceholder(context),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      height: 180,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(height: 8),
          Text('Image could not be loaded', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
