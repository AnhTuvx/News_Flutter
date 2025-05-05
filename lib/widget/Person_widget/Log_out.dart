import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../view/login_page.dart';

Future<void> signOut(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black, // Nền màu đen
        title: Text(
          "Xác nhận đăng xuất",
          style:
              TextStyle(color: Colors.white, fontSize: 18), // Tiêu đề màu trắng
        ),
        content: Text(
          "Bạn có chắc chắn muốn đăng xuất không?",
          style: TextStyle(
              color: Colors.white, fontSize: 16), // Nội dung màu trắng
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng hộp thoại nếu chọn "Hủy"
            },
            child: Text(
              "Hủy",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Đóng hộp thoại sau khi xác nhận
              await _performSignOut(context); // Gọi hàm đăng xuất
            },
            child: Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _performSignOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut(); // Thực hiện đăng xuất
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Đã đăng xuất thành công.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
    // Điều hướng về màn hình đăng nhập và xoá toàn bộ stack navigation
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Lỗi đăng xuất: $e",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
