import 'package:flutter/material.dart';
import 'package:news_app_flutter/pages.dart/test2.dart';
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
    CaiDat(), // Trang Hồ sơ
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
      appBar: AppBar(
        title: Text(_getTitle(_selectedIndex)),
      ),
      body: _pages[_selectedIndex],
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
            icon: Icon(Icons.notifications),
            label: 'Thông Báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ Sơ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài Đặt',
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
