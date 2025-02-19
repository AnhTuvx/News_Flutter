import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TienIchWebViewPage extends StatefulWidget {
  final String url;

  const TienIchWebViewPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _TienIchWebViewPageState createState() => _TienIchWebViewPageState();
}

class _TienIchWebViewPageState extends State<TienIchWebViewPage> {
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
      appBar: AppBar(),
      body: WebViewWidget(controller: _controller),
    );
  }
}
