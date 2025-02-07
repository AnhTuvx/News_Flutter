// // lib/services/dantri_service.dart
// import 'package:http/http.dart' as http;
// import 'package:news_app_flutter/model/rss_feed_model.dart';
// import 'package:xml/xml.dart' as xml;

// class DantriService {
//   Future<List<DantriArticle>> fetchArticles() async {
//     final url = 'https://dantri.com.vn/rss/du-lich.rss';
//     List<DantriArticle> articles = [];

//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       print(
//           'Response from $url: ${response.body}'); // Kiểm tra nội dung phản hồi

//       try {
//         final document = xml.XmlDocument.parse(response.body);

//         document.findAllElements('item').forEach((item) {
//           final title = item.findElements('title').first.text;
//           final description = item.findElements('description').first.text;
//           final pubDate = item.findElements('pubDate').first.text;
//           final link = item.findElements('link').first.text;
//           final imageUrl = item.findElements('enclosure').isNotEmpty
//               ? item.findElements('enclosure').first.getAttribute('url') ?? ''
//               : ''; // Sử dụng link ảnh nếu có thẻ `enclosure`

//           articles.add(DantriArticle(
//             title: title,
//             description: description,
//             pubDate: pubDate,
//             link: link,
//             imageUrl: imageUrl,
//           ));
//         });
//       } catch (e) {
//         print('Error parsing XML for $url: $e');
//       }
//     } else {
//       print('Failed to load RSS feed from $url: ${response.statusCode}');
//     }

//     return articles;
//   }
// }
