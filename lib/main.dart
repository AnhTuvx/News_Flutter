import 'package:flutter/material.dart';
import 'package:news_app_flutter/pages.dart/homepage.dart';
import 'package:news_app_flutter/pages.dart/rss_feed_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tin tức Du lịch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
