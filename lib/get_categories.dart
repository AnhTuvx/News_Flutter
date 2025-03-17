Map<String, Map<String, String>> categories = {
  "tin_moi": {
    "NLD": "https://nld.com.vn/rss/home.rss",
    "VnExpress": "https://vnexpress.net/rss/tin-moi-nhat.rss",
    "BaoGiaoThong": "https://www.baogiaothong.vn/rss/home.rss",
    "VnEconomy": "https://vneconomy.vn/tin-moi.rss",
  },
  "kinh_te": {
    "NLD": "https://nld.com.vn/rss/kinh-te.rss",
    "VnExpress": "https://vnexpress.net/rss/kinh-doanh.rss",
    "BaoGiaoThong": "https://www.baogiaothong.vn/rss/kinh-te.rss",
    "VnEconomy": "https://vneconomy.vn/tai-chinh.rss",
  },
  "thoi_su": {
    "NLD": "https://nld.com.vn/rss/thoi-su.rss",
    "VnExpress": "https://vnexpress.net/rss/thoi-su.rss",
    "BaoGiaoThong": "https://www.baogiaothong.vn/rss/thoi-su.rss",
  },
  "giao_duc": {
    "NLD": "https://nld.com.vn/rss/giao-duc-khoa-hoc.rss",
    "VnExpress": "https://vnexpress.net/rss/giao-duc.rss",
    "BaoGiaoThong": "https://dantri.com.vn/rss/home.rss",
  },
  "phap_luat": {
    "NLD": "https://nld.com.vn/rss/phap-luat.rss",
    "VnExpress": "https://vnexpress.net/rss/phap-luat.rss",
    "BaoGiaoThong": "https://www.baogiaothong.vn/rss/phap-luat.rss",
  },
  "giai_tri": {
    "NLD": "https://nld.com.vn/rss/giai-tri.rss",
    "VnExpress": "https://vnexpress.net/rss/giai-tri.rss",
    "BaoGiaoThong": "https://www.baogiaothong.vn/rss/van-hoa-giai-tri.rss",
  },
  "the_thao": {
    "NLD": "https://nld.com.vn/rss/the-thao.rss",
    "VnExpress": "https://vnexpress.net/rss/the-thao.rss",
    "BaoGiaoThong": "https://www.baogiaothong.vn/rss/the-thao.rss",
  },
  "doi_song": {
    "NLD": "https://nld.com.vn/rss/doi-song.rss",
    "VnExpress": "https://vnexpress.net/rss/gia-dinh.rss",
    "BaoGiaoThong": "https://www.baogiaothong.vn/rss/chat-luong-song.rss",
    "VnEconomy": "https://vneconomy.vn/dan-sinh.rss",
  },
};

final domains = ['NLD', 'VnExpress', 'BaoGiaoThong', 'VnEconomy'];

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

List<String> getUrls(String category, {List<String> urlFilter = const []}) {
  final urls = <String>[];
  // Filter url chứa ở đây
  final filterUrls = domains.where((val) => urlFilter.contains(val)).toList();
  for (final domain in filterUrls) {
    final url = setUrl(category, domain);
    if (url.isNotEmpty) {
      urls.add(url);
    }
  }
  return urls;
}
