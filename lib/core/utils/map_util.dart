import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

Future<Uint8List> getBytesFromAsset(String path, [int width = 100]) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<Uint8List> getByteFromSvgAsset(String assetName,
    [double size = 64]) async {
  String svgString = await rootBundle.loadString(assetName);

  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '1');

  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(size, size));

  ui.Image image = await picture.toImage(64.toInt(), 64.toInt());
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

// get JSON file form assets
Future<String> getJsonFile(String path) async {
  return await rootBundle.loadString(path);
}
