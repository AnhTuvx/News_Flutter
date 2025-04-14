import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app_flutter/view/Book_mark_page.dart';
import 'package:news_app_flutter/view/login_page.dart';
import 'package:news_app_flutter/widget/Person_widget/Change_password.dart';
import 'package:news_app_flutter/widget/Person_widget/Log_out.dart';

import '../widget/Person_widget/Remove_acc.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String name = "Loading..."; // Giá trị mặc định ban đầu
  String email = "Loading..."; // Giá trị mặc định ban đầu

  @override
  void initState() {
    super.initState();
    loadUserInfo(); // Gọi hàm khi widget khởi tạo
  }

  Future<void> loadUserInfo() async {
    User? user =
        FirebaseAuth.instance.currentUser; // Lấy thông tin người dùng hiện tại
    if (user != null) {
      // Đọc tài liệu từ Firestore theo UID người dùng
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        // Kiểm tra nếu tài liệu tồn tại và cập nhật name và email
        setState(() {
          name = userDoc['name'] ?? "Unknown"; // Cập nhật name từ Firestore
          email = userDoc['email'] ?? "Unknown"; // Cập nhật email từ Firestore
        });
      } else {
        print("User document does not exist");
      }
    } else {
      print("No user is currently signed in");
    }
  }

  Future<void> _updateUserName(String newName) async {
    User? user =
        FirebaseAuth.instance.currentUser; // Lấy thông tin người dùng hiện tại
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Cập nhật theo UID của người dùng
            .update(
                {'name': newName}); // Cập nhật trường 'name' với giá trị mới
        print("Name updated successfully");
      } catch (e) {
        print("Error updating name: $e");
      }
    }
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Xóa tài khoản từ Firebase Authentication
        await user.delete();

        // Xóa dữ liệu người dùng từ Firestore (nếu có)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Tài khoản đã được xóa thành công."),
            backgroundColor: Colors.green,
          ),
        );

        // Điều hướng về trang đăng nhập
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      } else {
        print("No user is signed in.");
      }
    } catch (e) {
      if (e.toString().contains("requires-recent-login")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bạn cần đăng nhập lại để xóa tài khoản."),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditNameDialog() {
    TextEditingController _nameController = TextEditingController();
    _nameController.text = name; // Điền tên hiện tại vào ô nhập

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Nền màu đen
          title: Text(
            "Chỉnh Sửa Tên",
            style: TextStyle(
              color: Colors.white, // Màu chữ trắng
              fontSize: 22, // Kích thước chữ 18
            ),
          ),
          content: TextField(
            controller: _nameController,
            style: TextStyle(
              color: Colors.white, // Màu chữ trắng
              fontSize: 18, // Kích thước chữ 18
            ),
            decoration: InputDecoration(
              hintText: "Nhập tên của bạn",
              hintStyle: TextStyle(
                color: Colors.grey[400], // Màu chữ gợi ý (hint) nhạt hơn
                fontSize: 18, // Kích thước chữ gợi ý 18
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại mà không làm gì
              },
              child: Text(
                "Hủy",
                style: TextStyle(
                  color: Colors.white, // Màu chữ trắng
                  fontSize: 18, // Kích thước chữ 18
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  await _updateUserName(newName); // Cập nhật tên trên Firestore
                  setState(() {
                    name = newName; // Cập nhật giao diện
                  });
                }
                Navigator.pop(context); // Đóng hộp thoại sau khi cập nhật
              },
              child: Text(
                "Lưu",
                style: TextStyle(
                  color: Colors.white, // Màu chữ trắng
                  fontSize: 18, // Kích thước chữ 18
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, bottom: 16, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[700],
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name, // Hiển thị name từ Firestore
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      email, // Hiển thị email từ Firestore
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
                SizedBox(width: 40),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    _showEditNameDialog(); // Gọi hộp thoại chỉnh sửa tên
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Menu Options
            buildMenuItem(
              icon: Icons.add_to_photos_outlined,
              text: "Danh sách tin yêu thích",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookMarkPage()),
                );
              },
            ),
            buildMenuItem(
              icon: Icons.lock,
              text: "Thay đổi mật khẩu",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
            buildMenuItem(
              icon: Icons.delete,
              text: "Xóa tài khoản",
              onTap: () {
                _showDeleteConfirmationDialog(
                    context); // Hiển thị hộp thoại xác nhận
              },
            ),

            buildMenuItem(
              icon: Icons.logout_outlined,
              text: "Đăng xuất",
              onTap: () => signOut(context),
            ),
            // Face ID / Touch ID with Toggle
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
