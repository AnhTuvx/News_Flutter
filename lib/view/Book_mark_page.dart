import 'package:flutter/material.dart';
import 'package:news_app_flutter/widget/Bookmark/BookmarkProvider.dart';
import 'package:provider/provider.dart';
import 'package:news_app_flutter/view/detail_page.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Image.asset(
            "lib/img/Logo2.png",
            height: 70, // Sử dụng BoxFit.contain để hiển thị đầy đủ logo
          ),
        ),
      ),
      body: Container(
        color: Colors.black, // Nền toàn trang màu đen
        child: Consumer<BookmarkProvider>(
          builder: (context, bookmarkProvider, child) {
            final bookmarkedFeeds = bookmarkProvider.bookmarkedFeeds;

            if (bookmarkedFeeds.isEmpty) {
              return const Center(
                child: Text(
                  'Chưa có danh sách tin',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16), // Màu chữ thông báo
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      left: 16, right: 16, top: 16), // Khoảng cách xung quanh
                  child: Text(
                    'Danh sách tin yêu thích',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: bookmarkedFeeds.length,
                    itemBuilder: (context, index) {
                      final feed = bookmarkedFeeds[index];
                      return Column(
                        children: [
                          SizedBox(height: 8),
                          Card(
                            color: Colors.white, // Nền của Card là màu trắng
                            child: ListTile(
                              leading: feed.imageUrl != null
                                  ? Image.network(
                                      feed.imageUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.article,
                                      color: Colors.black),
                              title: Text(
                                feed.title,
                                style: const TextStyle(
                                  color:
                                      Colors.black, // Màu chữ trong Card là đen
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                feed.source,
                                style: const TextStyle(color: Colors.black),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  bookmarkProvider
                                      .toggleBookmark(feed); // Xóa bookmark
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Tin đã được xóa!'),
                                    ),
                                  );
                                },
                              ),
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
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
