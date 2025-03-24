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
    loadBookmarks(); // Tải dữ liệu từ Firestore khi khởi tạo Provider
  }

  Future<void> loadBookmarks() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc['saveFeed'] != null) {
        List<Map<String, dynamic>> saveFeed =
            List<Map<String, dynamic>>.from(userDoc['saveFeed']);
        _bookmarkedFeeds = saveFeed.map((map) => RssFeed.fromMap(map)).toList();
        notifyListeners(); // Thông báo UI cập nhật
      }
    }
  }

  Future<void> toggleBookmark(RssFeed feed) async {
    User? user = _auth.currentUser;
    if (user != null) {
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
  }

  bool isBookmarked(String link) {
    return _bookmarkedFeeds.any((element) => element.link == link);
  }
}
