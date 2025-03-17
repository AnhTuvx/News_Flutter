import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_app_flutter/get_categories.dart';
import 'package:news_app_flutter/model/category_model.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';
import 'package:news_app_flutter/services/sort.dart';
import 'package:news_app_flutter/services/vnexpress.dart';
import 'package:news_app_flutter/view/detail_page.dart';
import 'package:news_app_flutter/widget/CategoryProvider.dart';
import 'package:news_app_flutter/widget/drawer_menu.dart';
import 'package:provider/provider.dart';

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
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
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
            title: Text('Chọn danh mục'),
            content: SingleChildScrollView(
              child: ListBody(
                children: categoryProvider.categories.map((category) {
                  return CheckboxListTile(
                    title: Text(category.name),
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
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Lưu'),
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
            urlsFilter: categoryProvider.stateDomain);
        return DefaultTabController(
          key: ValueKey(categoryProvider.selectedCategories.length), // Thêm Key
          length: categoryProvider.selectedCategories.length,
          child: Scaffold(
            drawer: DrawerMenuWidget(),
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu_rounded,color: Colors.red,),
                  onPressed: () {
                    print('123');
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
                  icon: Icon(Icons.settings),
                  onPressed: _showCategorySelectionDialog,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: Colors.black,
                  child: TabBar(
                    tabs: categoryProvider.selectedCategories.map((categoryId) {
                      CategoryModel? category = categoryProvider.categories
                          .firstWhere((cat) => cat.id == categoryId,
                              orElse: () => CategoryModel(
                                  id: "unknown", name: "Unknown"));
                      return Tab(text: category.name);
                    }).toList(),
                    onTap: (index) {
                      if (mounted) {
                        setState(() {
                          indexSelected = index;
                          futureFeeds = RssService().fetchRssFeeds(
                              categoryProvider
                                  .selectedCategories[indexSelected]);
                        });
                      }
                    },
                    indicatorColor: Colors.red,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.white,
                    isScrollable: true,
                    labelStyle: TextStyle(fontSize: 18),
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
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Không có dữ liệu'));
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
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            feed.imageUrl != null
                ? Image.network(feed.imageUrl!)
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
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 0.5,
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
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}
