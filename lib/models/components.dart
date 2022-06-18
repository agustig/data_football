import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:data_football/config.dart' as config;

/// A custom of imageProvider function
/// that usually use on [Container] decoration image.
ImageProvider loadImageProvider([String? imageSource]) {
  if (imageSource == null) {
    return IconImageProvider(Icons.hide_image, size: 100);
  }
  if (imageSource.startsWith('http')) {
    return NetworkImage(imageSource);
  }
  return AssetImage(imageSource);
}

/// A custom of [Image] widget.
///
/// Can select automatically a image source which is from assets or network.
/// Also can load image with ".svg" format extension
Widget loadImage({String? imageSource, double? width, double? height}) {
  // Check if has none of image return defaul image
  if (imageSource == null) {
    return const Icon(Icons.hide_image);
  }

  // Check if image has .svg format
  if (imageSource.endsWith('.svg')) {
    if (imageSource.startsWith('http')) {
      return SvgPicture.network(
        imageSource,
        width: width,
        height: height,
      );
    } else {
      return SvgPicture.asset(
        imageSource,
        width: width,
        height: height,
      );
    }
  }

  if (imageSource.startsWith('http')) {
    return Image.network(
      imageSource,
      width: width,
      height: height,
    );
  }

  return Image.asset(
    imageSource,
    width: width,
    height: height,
  );
}

/// A function thats can calculate year between past [DateTime] and now.
int calculateAge(DateTime birthDate) {
  final currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  if (birthDate.month > currentDate.month) {
    age--;
  } else if (birthDate.month == currentDate.month) {
    if (birthDate.day > currentDate.day) {
      age--;
    }
  }
  return age;
}

/// Return time distence from time now.
String calculateTimePassed(DateTime pastDate) {
  final currentDate = DateTime.now();
  final yearDifferent = currentDate.year - pastDate.year;
  final monthDifferent = currentDate.month - pastDate.month;
  final dayDifferent = currentDate.day - pastDate.day;
  final hourDifferent = currentDate.hour - pastDate.hour;
  final minuteDifferent = currentDate.minute - pastDate.minute;

  if (yearDifferent > 0) {
    return DateFormat.yMMMd().format(pastDate);
  } else if (monthDifferent > 0) {
    return DateFormat.MMMMd().format(pastDate);
  } else if (dayDifferent > 0) {
    if (dayDifferent == 1) {
      return 'Yesterday';
    }
    return '$dayDifferent days ago';
  } else if (hourDifferent > 0) {
    return '$hourDifferent hours ago';
  } else if (minuteDifferent > 3) {
    return '$minuteDifferent minutes ago';
  } else {
    return 'Just now';
  }
}

/// The custom class that use for build image from [Icons] object
class IconImageProvider extends ImageProvider<IconImageProvider> {
  IconImageProvider(
    this.icon, {
    this.scale = 1.0,
    this.size = 48,
    this.color = Colors.black87,
  });

  final IconData icon;
  final double scale;
  final int size;
  final Color color;

  @override
  Future<IconImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter load(IconImageProvider key, DecoderCallback decode) =>
      OneFrameImageStreamCompleter(
        _loadAsync(key),
      );

  Future<ImageInfo> _loadAsync(IconImageProvider key) async {
    assert(key == this);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(scale, scale);
    final textPainter = TextPainter(textDirection: ui.TextDirection.rtl);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontFamily: icon.fontFamily,
        color: color,
        fontSize: size.toDouble(),
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
    final image = await recorder.endRecording().toImage(size, size);
    return ImageInfo(image: image, scale: key.scale);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final IconImageProvider typedOther = other;
    return icon == typedOther.icon &&
        scale == typedOther.scale &&
        size == typedOther.size &&
        color == typedOther.color;
  }

  @override
  int get hashCode => hashValues(icon.hashCode, scale, size, color);

  @override
  String toString() =>
      '$runtimeType(${describeIdentity(icon)}, scale: $scale, size: $size, color: $color)';
}

/// [footballDataApis] return jsonData witch get from api.football-data.org
footballDataApis({
  required String endPoint,
  Map<String, String>? filters,
}) async {
  const domain = 'api.football-data.org';
  try {
    // Cheking API key if zero value, throw exeption
    if (config.dataFootballApiKey == '') {
      throw 'Please insert your Football-data.org API key!';
    } else {
      final auth = {'X-Auth-Token': config.dataFootballApiKey};
      final url = Uri.http(domain, '/v4/$endPoint', filters);
      final rawJsonString = await getFromUrl(url, headers: auth);
      final jsonMap = jsonDecode(rawJsonString);
      return jsonMap;
    }
  } catch (error) {
    return Future.error(error.toString());
  }
}

/// Return string data from url
Future<String> getFromUrl(Uri url, {Map<String, String>? headers}) async {
  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 400) {
      final errorMessage = jsonDecode(response.body)['message'];
      throw errorMessage;
    } else {
      throw HttpException('${response.statusCode}');
    }
  } on SocketException catch (error) {
    return Future.error(error.toString());
  } on HttpException catch (error) {
    return Future.error(error.toString());
  } catch (error) {
    return Future.error(error.toString());
  }
}
