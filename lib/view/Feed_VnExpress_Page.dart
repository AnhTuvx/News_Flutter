import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:news_app_flutter/model/category_model.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';
import 'package:news_app_flutter/services/sort.dart';
import 'package:news_app_flutter/services/vnexpress.dart';
import 'detail_page.dart';

class VnExpressPage extends StatefulWidget {
  @override
  _VnExpressPageState createState() => _VnExpressPageState();
}

class _VnExpressPageState extends State<VnExpressPage> {
  late Future<List<RssFeed>> futureFeeds;
  FlutterTts flutterTts = FlutterTts();
  List<CategoryModel> categories = [
    CategoryModel(id: "rss_vnexpress", name: "vnexpress"),
  ];
  int indexSelected = 0;

  @override
  void initState() {
    super.initState();
    futureFeeds = RssService().fetchRssFeeds(categories[indexSelected].id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white, // Thay đổi màu nút Back thành màu trắng
          ),
          title: Text(
            "Tổng Hợp Tin Tức",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        body: TabBarView(
          children: List.generate(categories.length, (index) {
            return FutureBuilder<List<RssFeed>>(
              future: futureFeeds,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có dữ liệu'));
                } else {
                  // Sắp xếp các tin tức trước khi hiển thị
                  List<RssFeed> sortedFeeds = sortFeedsByDate(snapshot.data!);
                  return ListView.builder(
                    itemCount: sortedFeeds.length,
                    itemBuilder: (context, index) {
                      RssFeed feed = sortedFeeds[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                logoUrl: feed.logoUrl!,
                                url: feed.link,
                              ),
                            ),
                          );
                        },
                        child: buildFeedItem(feed),
                      );
                    },
                  );
                }
              },
            );
          }),
        ),
      ),
    );
  }

  Widget buildFeedItem(RssFeed feed) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            feed.imageUrl != null
                ? CachedNetworkImage(imageUrl: feed.imageUrl!)
                : Image.asset(
                    'lib/img/NotFound.png',
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    feed.title,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 252, 252),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: feed.logoUrl!,
                        width: 100,
                        height: 50,
                      ),
                      Text(
                        formatHoursString(feed.pubDate),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _speak(feed.title);
                        },
                        child: Icon(
                          Icons.headphones,
                          color: Colors.white, // Màu trắng
                          size: 30, // Kích thước icon (có thể thay đổi)
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.save,
                          color: Colors.white, // Màu trắng
                          size: 30, // Kích thước icon (có thể thay đổi)
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white, // Màu trắng
              thickness: 0.5, // Độ dày
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("vi-VN"); // Thiết lập ngôn ngữ Tiếng Việt
    await flutterTts.setSpeechRate(0.5); // Tốc độ đọc (0.0 đến 1.0)
    await flutterTts.setVolume(1.0); // Âm lượng
    await flutterTts.setPitch(1.0); // Cao độ giọng nói
    await flutterTts.speak(text); // Bắt đầu đọc văn bản
  }
}
