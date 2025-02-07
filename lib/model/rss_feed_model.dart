class RssFeed {
  final String title;
  final String description;
  final String pubDate;
  final String link;
  final String source;
  final String? imageUrl; // Thêm trường hình ảnh

  RssFeed({
    required this.title,
    required this.description,
    required this.pubDate,
    required this.link,
    required this.source,
    this.imageUrl, // Thêm trường hình ảnh
  });
}
