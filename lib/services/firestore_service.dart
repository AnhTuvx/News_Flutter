import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../get_categories.dart';

class FirebaseService{
  Future<List<QueryDocumentSnapshot>> _querySnapshotRssFeed()async{
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('rss_feeds');
    final snapshot = await collection.get();

    return snapshot.docs;
  }

  Future<void> getRssFeed()async{
    final query = await _querySnapshotRssFeed();
    for(final data in query ){
      categories[data.id] = data.data();
    }
  }

  Future<List<String>> getCategories() async{
    final query = await _querySnapshotRssFeed();
    final collection = <String>[];
    for(final data in query ){
      collection.add(data.id);
    }
    return collection;
  }
}