import 'package:flutter/material.dart';
import 'package:news_app_flutter/services/utilities_webview.dart';

class VietlottWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Đặt màu nền cho giao diện
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context,
                title: "Thời tiết Việt Nam",
                imagePath: 'lib/img/Thoitiet.jpg',
                url: 'https://www.accuweather.com/vi/vn/vietnam-weather',
              ),
              _buildSection(
                context,
                title: "Vietlott",
                imagePath: 'lib/img/Vietlott.jpg',
                url: 'https://www.kqxs.vn/xo-so-vietlott',
              ),
              _buildSection(
                context,
                title: "Xổ số",
                imagePath: 'lib/img/KQXL.jpg',
                url: 'https://www.kqxs.vn/#google_vignette',
              ),
              _buildSection(
                context,
                title: "Giá Vàng",
                imagePath: 'lib/img/gold.jpg',
                url: 'https://www.24h.com.vn/gia-vang-hom-nay-c425.html',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required String imagePath, required String url}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TienIchWebViewPage(url: url),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              height: 150,
              width: MediaQuery.of(context)
                  .size
                  .width, // Điều chỉnh kích thước tự động theo màn hình
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
