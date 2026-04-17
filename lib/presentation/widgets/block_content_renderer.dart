import 'package:flutter/material.dart';
import '../../domain/entities/content_block.dart';
import 'article_chart.dart';
import 'article_image.dart';
import 'markdown_renderer.dart';

/// Renders a list of [ContentBlock]s into the appropriate widgets.
///
/// - `text`  → [MarkdownRenderer]
/// - `image` → [ArticleImage]
/// - `chart` → [ArticleChart]
class BlockContentRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;

  const BlockContentRenderer({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final block in blocks) _buildBlock(context, block)],
    );
  }

  Widget _buildBlock(BuildContext context, ContentBlock block) {
    return switch (block.type) {
      'text' => MarkdownRenderer(data: block.text ?? ''),
      'image' => ArticleImage(src: block.src ?? '', caption: block.caption),
      'chart' => ArticleChart(block: block),
      _ => const SizedBox.shrink(),
    };
  }
}
