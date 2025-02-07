import 'package:http/http.dart' as http;
import 'package:news_app_flutter/model/rss_feed_model.dart';
import 'package:xml/xml.dart' as xml;
import 'package:collection/collection.dart'; // Thêm dòng này để sử dụng firstOrNull

class RssService {
  Future<List<RssFeed>> fetchRssFeeds() async {
    final urls = [
      'https://vneconomy.vn/tin-moi.rss',
      'https://vnexpress.net/rss/gia-dinh.rss',
    ];

    List<RssFeed> feeds = [];

    for (var url in urls) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        try {
          final document = xml.XmlDocument.parse(response.body);
          final channel = document.findAllElements('channel').firstOrNull;

          if (channel == null) {
            print('No channel element found in $url');
            continue;
          }

          final channelTitle =
              channel.findElements('title').firstOrNull?.text ?? 'Unknown';

          for (var item in channel.findElements('item')) {
            try {
              final titleElement = item.findElements('title').firstOrNull;
              final descriptionElement =
                  item.findElements('description').firstOrNull;
              final pubDateElement = item.findElements('pubDate').firstOrNull;
              final linkElement = item.findElements('link').firstOrNull;

              if (titleElement == null || linkElement == null) {
                print('Missing title or link in item from $url');
                continue;
              }

              final title = titleElement.text;
              final description = descriptionElement?.text ?? '';
              final pubDate = pubDateElement?.text ?? '';
              final link = linkElement.text;

              // Trích xuất ảnh
              String? imageUrl;

              // Kiểm tra 'media:content' và 'enclosure'
              final media = item.findElements('media:content').firstOrNull;
              final enclosure = item.findElements('enclosure').firstOrNull;

              if (media != null) {
                imageUrl = media.getAttribute('url');
              } else if (enclosure != null) {
                imageUrl = enclosure.getAttribute('url');
              } else {
                imageUrl = _extractImageFromDescription(description);
              }

              feeds.add(RssFeed(
                title: title,
                description: description,
                pubDate: pubDate,
                link: link,
                source: channelTitle,
                imageUrl: imageUrl,
              ));
            } catch (e) {
              print('Error parsing item from $url: $e');
              continue;
            }
          }
        } catch (e) {
          print('Error parsing XML from $url: $e');
          continue;
        }
      } else {
        print('Failed to load RSS feed from $url: ${response.statusCode}');
      }
    }

    return feeds;
  }

  // Trích xuất ảnh từ description bằng RegExp
  String? _extractImageFromDescription(String description) {
    try {
      final RegExp regExp =
          RegExp(r'<img[^>]+src="([^">]+)"', caseSensitive: false);
      final match = regExp.firstMatch(description);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    } catch (e) {
      print('Error extracting image from description: $e');
    }
    return null;
  }
}
