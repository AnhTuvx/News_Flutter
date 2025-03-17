import 'package:intl/intl.dart';
import 'package:news_app_flutter/model/rss_feed_model.dart';

// Xử lý ngày tháng thành định dạng 'dd/MM/yyyy'
String formatDateString(String dateString) {
  if (dateString == null || dateString.trim().isEmpty) {
    print('Error: dateString is null or empty');
    return '';
  }
  try {
    DateTime dateTime = parseWithMultipleFormats(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  } catch (e) {
    print('Error parsing date: $e');
    return dateString; // Trả lại chuỗi ban đầu nếu không phân tích được
  }
}

// Xử lý chuỗi giờ thành chuỗi tương đối (ví dụ: 5 phút trước)
String formatHoursString(String dateString) {
  if (dateString == null || dateString.trim().isEmpty) {
    print('Error: dateString is null or empty');
    return '';
  }
  try {
    DateTime dateTime = parseWithMultipleFormats(dateString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    }
  } catch (e) {
    print('Error parsing date: $e');
    return dateString; // Trả lại chuỗi ban đầu nếu không phân tích được
  }
}

// Hàm hỗ trợ phân tích nhiều định dạng ngày khác nhau
DateTime parseWithMultipleFormats(String dateString) {
  List<String> formats = [
    "EEE, dd MMM yyyy HH:mm:ss Z",
    "dd MMM yyyy HH:mm:ss Z",
    "yyyy-MM-dd HH:mm:ss",
  ];

  for (String format in formats) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (_) {
      // Tiếp tục thử định dạng tiếp theo
    }
  }
  throw FormatException("Could not parse date: $dateString");
}

// Sắp xếp các RSS Feed theo thứ tự ngày giảm dần
List<RssFeed> sortFeedsByDate(List<RssFeed> feeds) {
  feeds.sort((a, b) {
    try {
      DateTime dateA = parseWithMultipleFormats(a.pubDate);
      DateTime dateB = parseWithMultipleFormats(b.pubDate);
      return dateB.compareTo(dateA); // Sắp xếp giảm dần
    } catch (e) {
      print('Error parsing feed dates: $e');
      return 0; // Giữ nguyên thứ tự nếu gặp lỗi
    }
  });
  return feeds;
}
