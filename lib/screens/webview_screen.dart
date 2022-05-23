import 'dart:io';
import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    Key? key,
    required this.team,
  }) : super(key: key);
  final FootballTeam team;

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
      appBar: AppBar(title: Text('${widget.team.name}\'s Sites')),
      body: WebView(initialUrl: widget.team.website),
    );
  }
}
