Map<String, Map<String, String>> categories = {
  "tin_moi": {
    "https://vtcnews.vn": "https://vtcnews.vn/rss/thoi-su.rss",
    "https://vnexpress.net": "https://vnexpress.net/rss/tin-moi-nhat.rss",
    "https://vneconomy.vn": "https://vneconomy.vn/tin-moi.rss",
  },
  "kinh_te": {
    "https://vtcnews.vn": "https://nld.com.vn/rss/kinh-te.rss",
    "https://vnexpress.net": "https://vnexpress.net/rss/kinh-doanh.rss",
    "https://vneconomy.vn": "https://vtcnews.vn/rss/kinh-te.rss",
  },
  "thoi_su": {
    "https://vtcnews.vn": "https://vnexpress.net/rss/thoi-su.rss",
    "https://vnexpress.net": "https://www.baogiaothong.vn/rss/thoi-su.rss",
    "https://vneconomy.vn": "https://nld.com.vn/rss/thoi-su.rss",
  },
  "rss_vnexpress": {
    "https://vtcnews.vn": "https://vnexpress.net/rss/thoi-su.rss",
    "https://vnexpress.net": "https://vnexpress.net/rss/tin-noi-bat.rss",
    "https://vneconomy.vn": "https://vnexpress.net/rss/gia-dinh.rss",
  },
};

final domains = [
  'https://vtcnews.vn',
  'https://vnexpress.net',
  'https://vneconomy.vn'
];

String setUrl(
  String category,
  String url,
) {
  final getUrl = categories[category];
  if (getUrl == null) {
    return "";
  }
  return getUrl[url] ?? "";
}

List<String> getUrls(String category) {
  final urls = <String>[];
  for (final domain in domains) {
    final url = setUrl(category, domain);
    if (url.isNotEmpty) {
      urls.add(url);
    }
  }
  return urls;
}
