import 'package:flutter/material.dart';
import 'package:news_app_flutter/services/TienIch_webview.dart';
import 'package:news_app_flutter/view/Feed_VnExpress_Page.dart';

class ListLogoPage extends StatefulWidget {
  const ListLogoPage({super.key});

  @override
  State<ListLogoPage> createState() => _ListLogoPageState();
}

class _ListLogoPageState extends State<ListLogoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tổng hợp tin tức",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VnExpressPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 80, // Giới hạn chiều rộng
                      height: 80, // Giới hạn chiều cao
                      child: Image.asset(
                        'lib/img/vnexpress_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VnExpressPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 80, // Giới hạn chiều rộng
                      height: 80, // Giới hạn chiều cao
                      child: Image.asset(
                        'lib/img/vtc_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VnExpressPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 80, // Giới hạn chiều rộng
                      height: 80, // Giới hạn chiều cao
                      child: Image.asset(
                        'lib/img/nld_logo.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VnExpressPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 80, // Giới hạn chiều rộng
                      height: 80, // Giới hạn chiều cao
                      child: Image.asset(
                        'lib/img/VNeco_logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
