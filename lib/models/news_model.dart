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
    required this.image,
    required this.publisher,
    required this.publisherLink,
  });

  final String title;
  final String link;
  final DateTime publishDate;
  final String image;
  final String publisher;
  final String publisherLink;

  static Stream<News> getNewsStream() async* {
    final url = Uri.parse(newsFeedUrl);
    final xmlString = await getFromUrl(url);
    final xmlDocument = XmlDocument.parse(xmlString);

    for (var xmlItem in xmlDocument.findAllElements('item')) {
      // Get metadata from news link
      final newsMetadata = await MetadataFetch.extract(
        xmlItem.findElements('link').single.text,
      );
      if (newsMetadata != null) {
        final titleMaybeNull = newsMetadata.title;
        final imageMaybeNull = newsMetadata.image;
        final linkMaybeNull = newsMetadata.url;
        if (titleMaybeNull != null &&
            imageMaybeNull != null &&
            linkMaybeNull != null) {
          final title = titleMaybeNull;
          final link = linkMaybeNull;
          final publishDate = DateFormat('d MMM yyyy HH:mm:ss z').parse(
              xmlItem.findElements('pubDate').single.text.split(', ')[1]);
          final image = imageMaybeNull;
          final publisher = xmlItem.findElements('source').single.text;
          final publisherLink = xmlItem
              .findElements('source')
              .map(
                (value) => value.getAttribute('url'),
              )
              .toList()[0]!;
          final news = News(
            title: title,
            link: link,
            publishDate: publishDate,
            image: image,
            publisher: publisher,
            publisherLink: publisherLink,
          );
          yield news;
        }
      }
    }
  }
}
