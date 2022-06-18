import 'package:intl/intl.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:xml/xml.dart';
import 'package:data_football/config.dart';
import 'package:data_football/models/models.dart';

/// Class for news blueprint
class News {
  News({
    required this.title,
    required this.link,
    required this.publishDate,
    this.image,
    required this.publisher,
  });

  final String title;
  final String link;
  final DateTime publishDate;
  final String? image;
  final String publisher;

  static Stream<News> getNewsStream() async* {
    final url = Uri.parse(newsFeedUrl);
    final xmlString = await getFromUrl(url);
    final xmlDocument = XmlDocument.parse(xmlString);

    for (var xmlItem in xmlDocument.findAllElements('item')) {
      final link = xmlItem.findElements('link').single.text;
      final newsMetadata = await MetadataFetch.extract(link);
      final publisher = xmlItem.findElements('source').single.text;
      final title = xmlItem
          .findElements('title')
          .single
          .text
          .replaceFirstMapped(' - $publisher', (match) => '');
      final image = newsMetadata!.image;
      final publishDate = DateFormat('d MMM yyyy HH:mm:ss z')
          .parse(xmlItem.findElements('pubDate').single.text.split(', ')[1]);
      final news = News(
        title: title,
        link: link,
        publishDate: publishDate,
        image: image,
        publisher: publisher,
      );
      yield news;
    } 
  }
}
