import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_app_flutter/model/category_model.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';
import 'package:news_app_flutter/services/sort.dart';
import 'package:news_app_flutter/services/Rss_Home_Service.dart';
import 'package:news_app_flutter/view/detail_page.dart';
import 'package:news_app_flutter/widget/CategoryProvider.dart';
import 'package:news_app_flutter/widget/drawer_menu.dart';
import 'package:provider/provider.dart';

import '../widget/Bookmark/BookmarkProvider.dart';

class RssFeedPage extends StatefulWidget {
  @override
  _RssFeedPageState createState() => _RssFeedPageState();
}

class _RssFeedPageState extends State<RssFeedPage> {
  late Future<List<RssFeed>> futureFeeds;
  FlutterTts flutterTts = FlutterTts();
  int indexSelected = 0;
  Timer? _timer;
  List<List<RssFeed>> cachedFeeds = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _startTimer();
  }

  void _loadInitialData() {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    futureFeeds = RssService()
        .fetchRssFeeds(categoryProvider.selectedCategories[indexSelected]);
    cachedFeeds = List.generate(
      categoryProvider.selectedCategories.length,
      (_) => [],
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3000), (timer) {
      if (mounted) {
        _refreshData();
      }
    });
  }

  void _refreshData() async {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    setState(() {
      futureFeeds = RssService()
          .fetchRssFeeds(categoryProvider.selectedCategories[indexSelected]);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showCategorySelectionDialog() {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    List<String> tempSelectedCategories =
        List.from(categoryProvider.selectedCategories);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            title: Center(
              child: Text(
                'Chọn danh mục',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: categoryProvider.categories.map((category) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      title: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      activeColor: Colors.blueAccent,
                      value: tempSelectedCategories.contains(category.id),
                      onChanged: (bool? value) {
                        if (mounted) {
                          setState(() {
                            if (value == true) {
                              tempSelectedCategories.add(category.id);
                            } else {
                              tempSelectedCategories.remove(category.id);
                            }
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Lưu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (mounted) {
                    categoryProvider
                        .updateSelectedCategories(tempSelectedCategories);
                    setState(() {
                      if (indexSelected >=
                          categoryProvider.selectedCategories.length) {
                        indexSelected =
                            categoryProvider.selectedCategories.length - 1;
                      }

                      futureFeeds = RssService().fetchRssFeeds(
                          categoryProvider.selectedCategories[indexSelected]);
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        futureFeeds = RssService().fetchRssFeeds(
          categoryProvider.selectedCategories[indexSelected],
          urlsFilter: categoryProvider.stateDomain,
        );
        return DefaultTabController(
          key: ValueKey(categoryProvider.selectedCategories
              .length), // Sử dụng Key để cập nhật TabController
          length: categoryProvider.selectedCategories.length,
          child: Scaffold(
            drawer: DrawerMenuWidget(),
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              title: Center(
                child: Image.asset(
                  "lib/img/Logo2.png",
                  height: 70,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.red,
                  onPressed: _showCategorySelectionDialog,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: Colors.black,
                  child: TabBar(
                    tabs: categoryProvider.selectedCategories.map((categoryId) {
                      CategoryModel? category =
                          categoryProvider.categories.firstWhere(
                        (cat) => cat.id == categoryId,
                        orElse: () =>
                            CategoryModel(id: "unknown", name: "Unknown"),
                      );
                      return Tab(text: category.name);
                    }).toList(),
                    onTap: (index) {
                      if (mounted) {
                        setState(() {
                          indexSelected = index;
                          futureFeeds = RssService().fetchRssFeeds(
                            categoryProvider.selectedCategories[indexSelected],
                          );
                        });
                      }
                    },
                    indicatorColor: Colors.red,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.white,
                    isScrollable: true,
                    labelStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: categoryProvider.selectedCategories.map((categoryId) {
                return FutureBuilder<List<RssFeed>>(
                  future: futureFeeds,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Không có tin tức cho loại báo bạn chọn'),
                      );
                    } else {
                      List<RssFeed> sortedFeeds =
                          sortFeedsByDate(snapshot.data!);
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
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget buildFeedItem(RssFeed feed) {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, child) {
        bool isBookmarked = bookmarkProvider
            .isBookmarked(feed.link); // Kiểm tra trạng thái bookmar
        return Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              feed.imageUrl != null
                  ? Image.network(
                      feed.imageUrl!,
                      width: double.infinity,
                      height: 190,
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
                      style: const TextStyle(
                        color: Colors.white,
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
                          formatHoursString(feed.pubDate),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _speak(feed.title);
                          },
                          child: const Icon(
                            Icons.headphones,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            bookmarkProvider
                                .toggleBookmark(feed); // Thêm hoặc xóa bookmark
                          },
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons
                                    .bookmark_border, // Hiển thị icon dựa vào trạng thái
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.5,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}
