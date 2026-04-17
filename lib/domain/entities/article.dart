import 'content_block.dart';

class Article {
  final String id;
  final String title;
  final String description;
  final String content;
  final List<ContentBlock>? contentBlocks;
  final String date;
  final String author;
  final List<String> tags;
  final int readTimeMinutes;

  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    this.contentBlocks,
    required this.date,
    required this.author,
    required this.tags,
    required this.readTimeMinutes,
  });

  bool get hasRichContent => contentBlocks != null && contentBlocks!.isNotEmpty;
}
