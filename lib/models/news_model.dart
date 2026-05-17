class NewsModel {
  final int id;
  final String? title;
  final String? summary;
  final String? image;
  final String? description;
  final String? category;
  final String? author;
  final String? publishedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.category,
    required this.image,
    required this.author,
    required this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final title = _asString(json['title']);
    final summary = _asString(json['summary']);
    final content = _asString(json['content']);
    final image = _asString(json['image']);
    final category = _asString(json['category']);
    final author = _asString(json['author']);
    final publishedAt = _asString(json['published_at']);

    return NewsModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: title,
      summary: summary,
      description: content.isNotEmpty ? content : summary,
      category: category,
      image: image,
      author: author,
      publishedAt: publishedAt,
    );
  }

  static String _asString(dynamic value) {
    if (value == null) {
      return '';
    }

    final text = value.toString();
    if (text == 'null') {
      return '';
    }

    return text;
  }
}