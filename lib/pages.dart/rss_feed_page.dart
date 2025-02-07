// lib/pages/rss_feed_page.dart
import 'package:flutter/material.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';
import 'package:news_app_flutter/services/vnexpress.dart';
import 'detail_page.dart';

class RssFeedPage extends StatefulWidget {
  @override
  _RssFeedPageState createState() => _RssFeedPageState();
}

class _RssFeedPageState extends State<RssFeedPage> {
  late Future<List<RssFeed>> futureFeeds;

  @override
  void initState() {
    super.initState();
    futureFeeds = RssService().fetchRssFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin tức Du lịch'),
      ),
      body: FutureBuilder<List<RssFeed>>(
        future: futureFeeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length > 5
                  ? 5
                  : snapshot.data!.length, // Hiển thị tất cả các bài viết
              itemBuilder: (context, index) {
                RssFeed feed = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(feed: feed),
                      ),
                    );
                  },
                  child: buildFeedItem(feed),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.black),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildFeedItem(RssFeed feed) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: feed.imageUrl != null
            ? Image.network(
                feed.imageUrl!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : Icon(Icons.image,
                size: 100), // Hiển thị icon nếu không có hình ảnh
        title: Text(feed.title),
        subtitle: Text('${feed.source} - ${feed.pubDate}'),
      ),
    );
  }
}
