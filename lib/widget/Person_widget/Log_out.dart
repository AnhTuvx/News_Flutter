import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signOut(BuildContext context, VoidCallback refreshData) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Xác nhận đăng xuất",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: Text(
          "Bạn có chắc chắn muốn đăng xuất không?",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Hủy",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performSignOut(context, refreshData);
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

Future<void> _performSignOut(
    BuildContext context, VoidCallback refreshData) async {
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

    // Gọi hàm làm mới dữ liệu
    refreshData();
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
