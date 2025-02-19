import 'package:intl/intl.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';

String formatDateString(String dateString) {
  try {
    DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z");
    DateTime dateTime = format.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  } catch (e) {
    print('Error parsing date: $e');
    return dateString; // Return the original string if parsing fails
  }
}

String formatHoursString(String dateString) {
  try {
    DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z");
    DateTime dateTime = format.parse(dateString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${difference.inDays} ngày trước';
    }
  } catch (e) {
    print('Error parsing date: $e');
    return dateString; // Return the original string if parsing fails
  }
}

List<RssFeed> sortFeedsByDate(List<RssFeed> feeds) {
  feeds.sort((a, b) {
    DateTime dateA = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(a.pubDate);
    DateTime dateB = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(b.pubDate);
    return dateB.compareTo(dateA); // Sorts in descending order
  });
  return feeds;
}
