import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/rss_feed_model.dart';

class BookmarkProvider with ChangeNotifier {
  List<RssFeed> _bookmarkedFeeds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<RssFeed> get bookmarkedFeeds => _bookmarkedFeeds;

  BookmarkProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      loadBookmarks(); // Tự động tải dữ liệu khi đăng nhập mới
    });
  }

  Future<void> loadBookmarks() async {
    User? user = _auth.currentUser;

    _bookmarkedFeeds.clear(); // Xóa danh sách cũ trước khi tải mới

    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc['saveFeed'] != null) {
        List<Map<String, dynamic>> saveFeed =
            List<Map<String, dynamic>>.from(userDoc['saveFeed']);
        _bookmarkedFeeds = saveFeed.map((map) => RssFeed.fromMap(map)).toList();
        notifyListeners();
      }
    }
  }

  Future<void> toggleBookmark(RssFeed feed, BuildContext context) async {
    User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để lưu tin yêu thích')),
      );
      return;
    }

    if (_bookmarkedFeeds.any((element) => element.link == feed.link)) {
      _bookmarkedFeeds.removeWhere((element) => element.link == feed.link);
    } else {
      _bookmarkedFeeds.add(feed);
    }

    await _firestore.collection('users').doc(user.uid).update({
      'saveFeed': _bookmarkedFeeds.map((feed) => feed.toMap()).toList(),
    });

    notifyListeners();
  }

  bool isBookmarked(String link) {
    return _bookmarkedFeeds.any((element) => element.link == link);
  }
}
