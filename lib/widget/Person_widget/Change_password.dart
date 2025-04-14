import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app_flutter/widget/UI_widget/text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _matKhauMoiController = TextEditingController();
  final TextEditingController _xacNhanMatKhauController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _thayDoiMatKhau() async {
    String matKhauMoi = _matKhauMoiController.text.trim();
    String xacNhanMatKhau = _xacNhanMatKhauController.text.trim();

    if (matKhauMoi.isEmpty || xacNhanMatKhau.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng điền đầy đủ thông tin."),
        ),
      );
      return;
    }

    if (matKhauMoi != xacNhanMatKhau) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mật khẩu xác nhận không khớp."),
        ),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(matKhauMoi);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Thay đổi mật khẩu thành công."),
          ),
        );
        Navigator.pop(context); // Quay lại màn hình trước đó
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Thay đổi mật khẩu",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Nút Back màu trắng
      ),
      backgroundColor: Colors.black, // Nền màu đen
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height / 2.7,
              child: Image.asset('lib/img/Forgot password-rafiki.png'),
            ),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: _matKhauMoiController,
              hintText: 'Nhập mật khẩu mới',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: _xacNhanMatKhauController,
              hintText: 'Nhập lại mật khẩu mới',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _thayDoiMatKhau,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  "Cập nhật mật khẩu",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
