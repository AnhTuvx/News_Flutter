import 'package:flutter/material.dart';
import 'package:news_app_flutter/widget/Vietlott_KQXS_page.dart';

class TienIchPage extends StatefulWidget {
  const TienIchPage({super.key});

  @override
  State<TienIchPage> createState() => _TienIchPageState();
}

class _TienIchPageState extends State<TienIchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Image.asset(
            "lib/img/Logo2.png",
            height: 70, // Sử dụng BoxFit.contain để hiển thị đầy đủ logo
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tiện ích",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            // ListLogoPage(),
            SizedBox(height: 8.0),
            VietlottWidget(),
          ],
        ),
      ),
    );
  }
}
