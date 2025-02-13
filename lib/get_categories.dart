Map<String, Map<String, String>> categories = {
  "tin_moi": {
    "https://vtcnews.vn": "https://vtcnews.vn/rss/thoi-su.rss",
    "https://vnexpress.net": "https://vnexpress.net/rss/tin-moi-nhat.rss",
    "https://vneconomy.vn/": "https://vneconomy.vn/tin-moi.rss",
  },
  // "kinh_doanh": {
  //   "https://vneconomy.vn": "https://vneconomy.vn/chung-khoan.rss",
  //   "https://vnexpress.net": "https://vnexpress.net/rss/kinh-doanh.rss",
  // },
  // "kinh_te": {
  //   "https://vneconomy.vn": "https://vneconomy.vn/kinh-te-so.rss",
  //   "https://vnexpress.net": "https://vnexpress.net/rss/kinh-doanh.rss",
  // }
};

final domains = [
  'https://vtcnews.vn',
  'https://vnexpress.net',
  'https://vneconomy.vn/'
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
