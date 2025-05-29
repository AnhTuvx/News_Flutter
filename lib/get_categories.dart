Map<String, Map<String, String>> categories = {
  "tin_moi": {
    "NLD": "https://nld.com.vn/rss/home.rss",
    "VnExpress": "https://vnexpress.net/rss/tin-moi-nhat.rss",
    "Bao Giao Thong": "https://www.baogiaothong.vn/rss/home.rss",
    "VnEconomy": "https://vneconomy.vn/tin-moi.rss",
    'Bao Van Hoa': "https://baovanhoa.vn/rss/home.rss",
    'VTC': "https://vtcnews.vn/rss/feed.rss",
  },
  "kinh_te": {
    "NLD": "https://nld.com.vn/rss/kinh-te.rss",
    "VnExpress": "https://vnexpress.net/rss/kinh-doanh.rss",
    "Bao Giao Thong": "https://www.baogiaothong.vn/rss/kinh-te.rss",
    "VnEconomy": "https://vneconomy.vn/tai-chinh.rss",
    "Bao Van Hoa": "https://baovanhoa.vn/rss/kinh-te-95.rss",
    "VTC": "https://vtcnews.vn/rss/kinh-te.rss",
  },
  "thoi_su": {
    "NLD": "https://nld.com.vn/rss/thoi-su.rss",
    "VnExpress": "https://vnexpress.net/rss/thoi-su.rss",
    "Bao Giao Thong": "https://www.baogiaothong.vn/rss/thoi-su.rss",
    'VTC': "https://vtcnews.vn/rss/thoi-su.rss",
  },
  "giao_duc": {
    "NLD": "https://nld.com.vn/rss/giao-duc-khoa-hoc.rss",
    "VnExpress": "https://vnexpress.net/rss/giao-duc.rss",
    "Bao Giao Thong": "https://dantri.com.vn/rss/home.rss",
    "VTC": "https://vtcnews.vn/rss/giao-duc.rss",
  },
  "phap_luat": {
    "NLD": "https://nld.com.vn/rss/phap-luat.rss",
    "VnExpress": "https://vnexpress.net/rss/phap-luat.rss",
    "Bao Giao Thong": "https://www.baogiaothong.vn/rss/phap-luat.rss",
    "Bao Van Hoa": "https://baovanhoa.vn/rss/phap-luat-173.rss",
    "VTC": "https://vtcnews.vn/rss/phap-luat.rss",
  },
  "giai_tri": {
    "NLD": "https://nld.com.vn/rss/giai-tri.rss",
    "VnExpress": "https://vnexpress.net/rss/giai-tri.rss",
    "Bao Giao Thong": "https://www.baogiaothong.vn/rss/van-hoa-giai-tri.rss",
    "Bao Van Hoa": "https://baovanhoa.vn/rss/giai-tri-172.rss",
    "VTC": "https://vtcnews.vn/rss/van-hoa-giai-tri.rss",
  },
  "the_thao": {
    "NLD": "https://nld.com.vn/rss/the-thao.rss",
    "VnExpress": "https://vnexpress.net/rss/the-thao.rss",
    "Bao Giao Thong": "https://www.baogiaothong.vn/rss/the-thao.rss",
    "Bao Van Hoa": "https://baovanhoa.vn/rss/the-thao-51.rss",
    "VTC": "https://vtcnews.vn/rss/the-thao.rss",
  },
  "doi_song": {
    "NLD": "https://nld.com.vn/rss/doi-song.rss",
    "VnExpress": "https://vnexpress.net/rss/gia-dinh.rss",
    "Bao Giao Thong": "https://www.baogiaothong.vn/rss/chat-luong-song.rss",
    "VnEconomy": "https://vneconomy.vn/dan-sinh.rss",
    "Bao Van Hoa": "https://baovanhoa.vn/rss/gia-dinh-163.rss",
    "VTC": "https://vtcnews.vn/rss/gia-dinh.rss",
  },
  "du_lich": {
    "NLD": "https://nld.com.vn/rss/du-lich-xanh.rss",
    "VnExpress": "https://vnexpress.net/rss/du-lich.rss",
    "Bao Van Hoa": "https://baovanhoa.vn/rss/du-lich-164.rss",
  },
};

final domains = [
  'NLD',
  'VnExpress',
  'Bao Giao Thong',
  'VnEconomy',
  'Bao Van Hoa',
  'VTC',
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
