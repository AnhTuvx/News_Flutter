import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app_flutter/view/home_page.dart';
import 'package:news_app_flutter/view/login_page.dart';
import 'package:news_app_flutter/widget/Bookmark_widget/BookmarkProvider.dart';
import 'package:news_app_flutter/widget/CategoryProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo khởi tạo Flutter
  await Firebase.initializeApp(); // Khởi tạo Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt banner debug
      home: AuthWrapper(), // Điều hướng dựa trên trạng thái người dùng
    );
  }
}

// AuthWrapper để xử lý luồng điều hướng
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Kiểm tra trạng thái người dùng
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
                child:
                    CircularProgressIndicator()), // Hiển thị khi chờ Firebase
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return HomePage(); // Chuyển đến trang chính nếu người dùng đã đăng nhập
        } else {
          return LoginScreen(); // Chuyển đến màn hình đăng nhập nếu chưa đăng nhập
        }
      },
    );
  }
}
