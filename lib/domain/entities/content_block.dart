/// A single content block within an article.
///
/// Supported types:
/// - `text`  : Markdown-formatted text string
/// - `image` : An image with optional caption (asset path or network URL)
/// - `chart` : A chart defined by chartType and structured data
class ContentBlock {
  final String type;
  final String? text;
  final String? src;
  final String? caption;
  final String? chartType;
  final String? chartTitle;
  final List<String>? labels;
  final List<ChartDataSet>? datasets;

  const ContentBlock({
    required this.type,
    this.text,
    this.src,
    this.caption,
    this.chartType,
    this.chartTitle,
    this.labels,
    this.datasets,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: json['type'] as String,
      text: json['text'] as String?,
      src: json['src'] as String?,
      caption: json['caption'] as String?,
      chartType: json['chartType'] as String?,
      chartTitle: json['chartTitle'] as String?,
      labels: (json['labels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      datasets: (json['datasets'] as List<dynamic>?)
          ?.map((e) => ChartDataSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChartDataSet {
  final String label;
  final List<double> data;
  final String? color;

  const ChartDataSet({required this.label, required this.data, this.color});

  factory ChartDataSet.fromJson(Map<String, dynamic> json) {
    return ChartDataSet(
      label: json['label'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      color: json['color'] as String?,
    );
  }
}
