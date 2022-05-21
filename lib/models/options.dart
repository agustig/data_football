import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

dynamic shapshotCheck(AsyncSnapshot<Object?> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const CircularProgressIndicator();
  } else if (snapshot.hasError) {
    return Text(snapshot.error.toString());
  }
  return null;
}

ImageProvider loadImageProvider({String? imageSource}) {
  if (imageSource == null) {
    return IconImageProvider(Icons.hide_image, size: 100);
  }
  if (imageSource.startsWith('http')) {
    return NetworkImage(imageSource);
  }
  return AssetImage(imageSource);
}

Widget loadImage({String? imageSource, double? width, double? height}) {
  if (imageSource == null) {
    return const Icon(Icons.hide_image);
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

class IconImageProvider extends ImageProvider<IconImageProvider> {
  IconImageProvider(this.icon, {this.scale = 1.0, this.size = 48, this.color = Colors.black87,});

  final IconData icon;
  final double scale;
  final int size;
  final Color color;

  @override 
  Future<IconImageProvider> obtainKey(ImageConfiguration configuration) => SynchronousFuture(this);

  @override 
  ImageStreamCompleter load(IconImageProvider key, DecoderCallback decode) => OneFrameImageStreamCompleter(_loadAsync(key),);

  Future<ImageInfo> _loadAsync(IconImageProvider key) async {
    assert(key == this);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(scale, scale);
    final textPainter = TextPainter(textDirection: ui.TextDirection.rtl);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(fontFamily: icon.fontFamily, color: color, fontSize: size.toDouble(),),
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
    return icon == typedOther.icon && scale == typedOther.scale && size == typedOther.size && color == typedOther.color;
  }

  @override 
  int get hashCode => hashValues(icon.hashCode, scale, size, color);

  @override
  String toString() => '$runtimeType(${describeIdentity(icon)}, scale: $scale, size: $size, color: $color)';
}