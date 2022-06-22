import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView template
class WebViewScreen<T> extends StatefulWidget {
  const WebViewScreen({
    Key? key,
    required this.model,
  }) : super(key: key);
  final T model;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.model.name}\'s site'),
      ),
      body: WebView(
        initialUrl: widget.model.website,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
