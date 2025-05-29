import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Nền màu đen
          title: Text(
            "Xác nhận xóa tài khoản",
            style: TextStyle(
                color: Colors.white, fontSize: 18), // Tiêu đề màu trắng
          ),
          content: Text(
            "Bạn có chắc chắn muốn xóa tài khoản này không? Hành động này không thể hoàn tác.",
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
                await _deleteAccount(); // Gọi hàm xóa tài khoản
              },
              child: Text(
                "Xóa",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete(); // Xóa tài khoản từ Firebase Authentication
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Tài khoản đã được xóa thành công.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(
            context, (route) => route.isFirst); // Quay về trang chính
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Vui lòng đăng nhập lại để có thể xóa tài khoản !",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Xóa tài khoản",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Nút Back màu trắng
      ),
      backgroundColor: Colors.black, // Nền màu đen
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              _showDeleteConfirmationDialog(
                  context); // Hiển thị hộp thoại xác nhận xóa tài khoản
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Xóa tài khoản",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
