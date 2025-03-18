import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:news_app_flutter/view/login_page.dart'; // Import trang LoginScreen

class CaiDat extends StatefulWidget {
  const CaiDat({super.key});

  @override
  State<CaiDat> createState() => _CaiDatState();
}

class _CaiDatState extends State<CaiDat> {
  // Hàm để xử lý đăng xuất
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut(); // Đăng xuất người dùng
      // Điều hướng về màn hình LoginScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Hiển thị lỗi (nếu có) khi đăng xuất
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signOut, // Gọi hàm _signOut khi nhấn nút
          child: const Text('Đăng Xuất'),
        ),
      ),
    );
  }
}
