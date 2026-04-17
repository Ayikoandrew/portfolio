import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// A simple Markdown-subset renderer that supports headings, paragraphs,
/// inline code, fenced code blocks, bold, italic, lists, and tables.
class MarkdownRenderer extends StatelessWidget {
  final String data;

  const MarkdownRenderer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final blocks = _parseBlocks(data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((b) => _buildBlock(context, b)).toList(),
    );
  }

  List<_Block> _parseBlocks(String text) {
    final lines = text.split('\n');
    final blocks = <_Block>[];
    var i = 0;

    while (i < lines.length) {
      final line = lines[i];

      // Fenced code block
      if (line.trimLeft().startsWith('```')) {
        final lang = line.trim().substring(3).trim();
        final codeLines = <String>[];
        i++;
        while (i < lines.length && !lines[i].trimLeft().startsWith('```')) {
          codeLines.add(lines[i]);
          i++;
        }
        blocks.add(_Block.code(codeLines.join('\n'), lang));
        i++;
        continue;
      }

      // Table (lines containing |)
      if (line.contains('|') && line.trim().startsWith('|')) {
        final tableLines = <String>[];
        while (i < lines.length &&
            lines[i].contains('|') &&
            lines[i].trim().startsWith('|')) {
          tableLines.add(lines[i]);
          i++;
        }
        blocks.add(_Block.table(tableLines));
        continue;
      }

      // Heading
      if (line.startsWith('#')) {
        final match = RegExp(r'^(#{1,6})\s+(.*)$').firstMatch(line);
        if (match != null) {
          blocks.add(_Block.heading(match.group(2)!, match.group(1)!.length));
          i++;
          continue;
        }
      }

      // Unordered list item
      if (RegExp(r'^\s*[-*]\s+').hasMatch(line)) {
        final items = <String>[];
        while (i < lines.length && RegExp(r'^\s*[-*]\s+').hasMatch(lines[i])) {
          items.add(lines[i].replaceFirst(RegExp(r'^\s*[-*]\s+'), ''));
          i++;
        }
        blocks.add(_Block.list(items));
        continue;
      }

      // Ordered list item
      if (RegExp(r'^\s*\d+\.\s+').hasMatch(line)) {
        final items = <String>[];
        while (i < lines.length && RegExp(r'^\s*\d+\.\s+').hasMatch(lines[i])) {
          items.add(lines[i].replaceFirst(RegExp(r'^\s*\d+\.\s+'), ''));
          i++;
        }
        blocks.add(_Block.orderedList(items));
        continue;
      }

      // Empty line
      if (line.trim().isEmpty) {
        i++;
        continue;
      }

      // Paragraph — collect contiguous non-empty, non-special lines
      final paraLines = <String>[];
      while (i < lines.length &&
          lines[i].trim().isNotEmpty &&
          !lines[i].startsWith('#') &&
          !lines[i].trimLeft().startsWith('```') &&
          !RegExp(r'^\s*[-*]\s+').hasMatch(lines[i]) &&
          !RegExp(r'^\s*\d+\.\s+').hasMatch(lines[i]) &&
          !(lines[i].contains('|') && lines[i].trim().startsWith('|'))) {
        paraLines.add(lines[i]);
        i++;
      }
      if (paraLines.isNotEmpty) {
        blocks.add(_Block.paragraph(paraLines.join(' ')));
      }
    }

    return blocks;
  }

  Widget _buildBlock(BuildContext context, _Block block) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (block.type) {
      case _BlockType.heading:
        final style = switch (block.level) {
          1 => theme.textTheme.displaySmall,
          2 => theme.textTheme.headlineLarge,
          3 => theme.textTheme.headlineMedium,
          _ => theme.textTheme.headlineSmall,
        };
        return Padding(
          padding: EdgeInsets.only(top: block.level <= 2 ? 32 : 24, bottom: 12),
          child: Text(block.text, style: style),
        );

      case _BlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildRichText(
            context,
            block.text,
            theme.textTheme.bodyLarge!,
          ),
        );

      case _BlockType.code:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                block.text,
                style: GoogleFonts.firaCode(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark
                      ? const Color(0xFFE6EDF3)
                      : const Color(0xFF24292F),
                ),
              ),
            ),
          ),
        );

      case _BlockType.unorderedList:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: block.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 12),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildRichText(
                        context,
                        item,
                        theme.textTheme.bodyLarge!,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );

      case _BlockType.orderedList:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < block.items.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '${i + 1}.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildRichText(
                          context,
                          block.items[i],
                          theme.textTheme.bodyLarge!,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );

      case _BlockType.table:
        return _buildTable(context, block.items);
    }
  }

  Widget _buildRichText(
    BuildContext context,
    String text,
    TextStyle baseStyle,
  ) {
    final spans = _parseInline(text, baseStyle, context);
    return RichText(text: TextSpan(children: spans));
  }

  List<InlineSpan> _parseInline(
    String text,
    TextStyle baseStyle,
    BuildContext context,
  ) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(
      r'`([^`]+)`' // inline code
      r'|\*\*(.+?)\*\*' // bold
      r'|\*(.+?)\*', // italic
    );

    var lastEnd = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: baseStyle,
          ),
        );
      }
      if (match.group(1) != null) {
        // Inline code
        final isDark = Theme.of(context).brightness == Brightness.dark;
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFEFF1F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                match.group(1)!,
                style: GoogleFonts.firaCode(
                  fontSize: baseStyle.fontSize! - 1,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        );
      } else if (match.group(2) != null) {
        // Bold
        spans.add(
          TextSpan(
            text: match.group(2),
            style: baseStyle.copyWith(fontWeight: FontWeight.w700),
          ),
        );
      } else if (match.group(3) != null) {
        // Italic
        spans.add(
          TextSpan(
            text: match.group(3),
            style: baseStyle.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: baseStyle));
    }

    return spans;
  }

  Widget _buildTable(BuildContext context, List<String> lines) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Parse rows, skipping separator row
    final rows = <List<String>>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('|') && trimmed.contains('---')) continue;
      final cells = trimmed
          .split('|')
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList();
      if (cells.isNotEmpty) rows.add(cells);
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Table(
          border: TableBorder.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          children: [
            for (var i = 0; i < rows.length; i++)
              TableRow(
                decoration: BoxDecoration(
                  color: i == 0
                      ? (isDark ? AppColors.darkCard : AppColors.lightCard)
                      : null,
                ),
                children: rows[i]
                    .map(
                      (cell) => Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          cell,
                          style: i == 0
                              ? theme.textTheme.labelLarge
                              : theme.textTheme.bodySmall,
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Block model ---

enum _BlockType { heading, paragraph, code, unorderedList, orderedList, table }

class _Block {
  final _BlockType type;
  final String text;
  final int level;
  final List<String> items;

  const _Block._({
    required this.type,
    this.text = '',
    this.level = 0,
    this.items = const [],
  });

  factory _Block.heading(String text, int level) =>
      _Block._(type: _BlockType.heading, text: text, level: level);

  factory _Block.paragraph(String text) =>
      _Block._(type: _BlockType.paragraph, text: text);

  factory _Block.code(String text, String lang) =>
      _Block._(type: _BlockType.code, text: text);

  factory _Block.list(List<String> items) =>
      _Block._(type: _BlockType.unorderedList, items: items);

  factory _Block.orderedList(List<String> items) =>
      _Block._(type: _BlockType.orderedList, items: items);

  factory _Block.table(List<String> lines) =>
      _Block._(type: _BlockType.table, items: lines);
}
