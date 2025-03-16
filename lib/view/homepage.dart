import 'package:flutter/material.dart';
import 'package:news_app_flutter/view/Tien_ich_page.dart';
import 'package:news_app_flutter/view/test2.dart';
import 'package:news_app_flutter/widget/drawer_menu.dart';
import 'rss_feed_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RssFeedPage(), // Trang Home
    CaiDat(), // Trang Thông báo
    TienIchPage(), // Trang Hồ sơ
    CaiDat(), // Trang Cài đặt
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      drawer: DrawerMenuWidget(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_add),
            label: 'Đọc Sau',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Tiện Ích',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá Nhân',
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "Trang Chủ";
      case 1:
        return "Thông Báo";
      case 2:
        return "Hồ Sơ";
      case 3:
        return "Cài Đặt";
      default:
        return "Ứng Dụng";
    }
  }
}
