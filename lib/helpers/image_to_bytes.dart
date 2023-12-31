import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<Uint8List> imageTobytes(
  String path, {
  int width = 100,
}) async {
  late Uint8List bytes;
  final file = await DefaultCacheManager().getSingleFile(path);
  bytes = await file.readAsBytes();

  final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
  final frame = await codec.getNextFrame();
  final newByteData = await frame.image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  return newByteData!.buffer.asUint8List();
}
