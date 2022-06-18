import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    Key? key,
    required this.link,
  }) : super(key: key);
  final String link;

  @override
  State<WebViewScreen> createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(initialUrl: widget.link),
    );
  }
}
