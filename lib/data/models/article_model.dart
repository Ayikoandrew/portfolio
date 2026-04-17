import '../../domain/entities/article.dart';
import '../../domain/entities/content_block.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    super.contentBlocks,
    required super.date,
    required super.author,
    required super.tags,
    required super.readTimeMinutes,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String? ?? '',
      contentBlocks: (json['contentBlocks'] as List<dynamic>?)
          ?.map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: json['date'] as String,
      author: json['author'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      readTimeMinutes: json['readTimeMinutes'] as int,
    );
  }
}
