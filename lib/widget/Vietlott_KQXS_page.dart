import 'package:flutter/material.dart';
import 'package:news_app_flutter/services/TienIch_webview.dart';
import 'package:news_app_flutter/view/rss_feed_page.dart';

class VietlottWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vietlott",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TienIchWebViewPage(
                    url: 'https://www.kqxs.vn/xo-so-vietlott'),
              ),
            );
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'lib/img/Vietlott.jpg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Xổ số",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TienIchWebViewPage(
                    url: 'https://www.kqxs.vn/#google_vignette'),
              ),
            );
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'lib/img/KQXL.jpg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ],
    );
  }
}
