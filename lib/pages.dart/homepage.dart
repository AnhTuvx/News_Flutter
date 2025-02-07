// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'rss_feed_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chủ'),
      ),
      body: RssFeedPage(),
    );
  }
}
