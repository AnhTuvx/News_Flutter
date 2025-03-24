import 'package:intl/intl.dart';

class RssFeed {
  final String title;
  final String description;
  final String pubDate;
  final String link;
  final String source;
  final String? imageUrl;
  final String? logoUrl;

  RssFeed({
    required this.title,
    required this.description,
    required this.pubDate,
    required this.link,
    required this.source,
    this.imageUrl,
    this.logoUrl,
  });

  // Chuyển đổi từ RssFeed thành map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'pubDate': pubDate,
      'link': link,
      'source': source,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
    };
  }

  // Khởi tạo RssFeed từ map
  factory RssFeed.fromMap(Map<String, dynamic> map) {
    return RssFeed(
      title: map['title'],
      description: map['description'],
      pubDate: map['pubDate'],
      link: map['link'],
      source: map['source'],
      imageUrl: map['imageUrl'],
      logoUrl: map['logoUrl'],
    );
  }
}
