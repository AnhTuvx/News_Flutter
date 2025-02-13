import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:news_app_flutter/model/category_model.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';
import 'package:news_app_flutter/services/sort.dart';
import 'package:news_app_flutter/services/vnexpress.dart';
import 'detail_page.dart';

class RssFeedPage extends StatefulWidget {
  @override
  _RssFeedPageState createState() => _RssFeedPageState();
}

class _RssFeedPageState extends State<RssFeedPage> {
  late Future<List<RssFeed>> futureFeeds;
  FlutterTts flutterTts = FlutterTts();
  List<CategoryModel> categories = [
    CategoryModel(id: "tin_moi", name: "Tin mới"),
    CategoryModel(id: "kinh_doanh", name: "Kinh Doanh"),
    CategoryModel(id: "kinh_te", name: "Kinh Tế"),
    CategoryModel(id: "kinh_doanh", name: "Kinh Doanh"),
    CategoryModel(id: "kinh_te", name: "Kinh Tế"),
    CategoryModel(id: "kinh_doanh", name: "Kinh Doanh"),
    CategoryModel(id: "kinh_te", name: "Kinh Tế"),
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
          title: Text('Tin tức ${categories[indexSelected].name}'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.black, // Màu nền của TabBar

              child: TabBar(
                tabs: List.generate(categories.length, (index) {
                  return Tab(text: categories[index].name);
                }),
                onTap: (index) {
                  setState(() {
                    indexSelected = index;
                  });
                  futureFeeds =
                      RssService().fetchRssFeeds(categories[indexSelected].id);
                },
                indicatorColor: Colors.red, // Màu gạch dưới khi tab được chọn
                labelColor: Colors.red, // Màu chữ khi tab được chọn
                unselectedLabelColor:
                    Colors.white, // Màu chữ khi tab không được chọn
                isScrollable: true,
                labelStyle: TextStyle(fontSize: 18), // chinh kich thuoc chu
              ),
            ),
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
                  // Sort the feeds before displaying
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
                ? Image.network(
                    feed.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
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
                      Image.network(
                        feed.logoUrl!,
                        width: 100,
                        height: 50,
                      ),
                      Text(
                        formatDateString(feed.pubDate),
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
