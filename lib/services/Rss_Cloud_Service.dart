import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';

class RssServiceCloud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RssFeed>> fetchRssFeeds(String category) async {
    List<RssFeed> feeds = [];

    try {
      // Fetch dữ liệu từ Firestore
      QuerySnapshot querySnapshot = await _firestore
          .collection('rssFeeds')
          .where('category', isEqualTo: category)
          .get();

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;

          feeds.add(
            RssFeed(
              title: data['title'] ?? 'Unknown Title',
              description: data['description'] ?? '',
              pubDate: data['pubDate'] ?? '',
              link: data['link'] ?? '',
              source: data['source'] ?? 'Unknown Source',
              imageUrl: data['imageUrl'],
              logoUrl: data['logoUrl'],
            ),
          );
        } catch (e) {
          print('Error parsing feed document: $e');
          continue;
        }
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }

    return feeds;
  }
}
