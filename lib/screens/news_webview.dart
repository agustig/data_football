import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:data_football/models/models.dart';

/// WebView template
class NewsWebView extends StatefulWidget {
  const NewsWebView({
    Key? key,
    required this.news,
  }) : super(key: key);
  final News news;

  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  @override
  Widget build(BuildContext context) {
    final news = widget.news;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebView(
        initialUrl: news.link,
        javascriptMode: JavascriptMode.unrestricted,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: _shareNews,
                icon: const Icon(Icons.share),
              ),
              IconButton(
                onPressed: () {
                  // Change bookmark icon state
                  setState(() {
                    news.isBookmarked = !news.isBookmarked;
                  });
                },
                icon: news.isBookmarked
                    ? const Icon(Icons.bookmark)
                    : const Icon(Icons.bookmark_border),
              ),
              IconButton(
                onPressed: () {
                  showNewsOptionMenu(news);
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show BottomSheet contains menu
  showNewsOptionMenu(News news) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Wrap(
              children: [
                ListTile(
                  iconColor: Colors.black,
                  trailing: Wrap(
                    direction: Axis.horizontal,
                    children: [
                      IconButton(
                        onPressed: _shareNews,
                        icon: const Icon(Icons.share),
                      ),
                      IconButton(
                        onPressed: () {
                          // Change bookmark icon state
                          setState(() {
                            news.isBookmarked = !news.isBookmarked;
                          });
                        },
                        icon: news.isBookmarked
                            ? const Icon(Icons.bookmark)
                            : const Icon(Icons.bookmark_border),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.web),
                  title: const Text('View original web page'),
                  onTap: () => _launchUrl(news.link),
                ),
                ListTile(
                  leading: const Icon(Icons.launch),
                  title: Text('Go to ${news.publisher}'),
                  onTap: () => _launchUrl(news.publisherLink),
                ),
              ],
            );
          },
        );
      },
      useRootNavigator: true,
      isScrollControlled: true,
    ).then((value) => setState(() {}));
  }

  /// Launch Url to external application
  _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Share news
  void _shareNews() {
    final news = widget.news;
    Share.share('${news.publisher}: ${news.title}. ${news.link}');
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
}
