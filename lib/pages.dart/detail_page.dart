// lib/pages/detail_page.dart
import 'package:flutter/material.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';

class DetailPage extends StatelessWidget {
  final RssFeed feed;

  DetailPage({required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feed.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (feed.imageUrl != null && feed.imageUrl!.isNotEmpty)
              Image.network(feed.imageUrl!),
            SizedBox(height: 8),
            Text(
              feed.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Published on ${feed.pubDate}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(feed.description),
            SizedBox(height: 16),
            Text('Link: ${feed.link}'),
          ],
        ),
      ),
    );
  }
}
