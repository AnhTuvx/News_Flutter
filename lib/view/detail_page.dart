import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  final String url;
  final String logoUrl; // Add the logoUrl parameter

  const DetailPage({
    Key? key,
    required this.url,
    required this.logoUrl, // Add the logoUrl parameter
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          widget.logoUrl,
        ), // Add the logo to the AppBar
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
