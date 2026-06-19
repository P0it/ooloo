import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// RepaintBoundary 영역을 PNG 바이트로 캡처한다.
/// [pixelRatio] 3 → 360 논리폭 기준 1080px 결과물.
Future<Uint8List> captureBoundaryPng(GlobalKey key, {double pixelRatio = 3.0}) async {
  final ctx = key.currentContext;
  if (ctx == null) throw StateError('부적 위젯이 아직 마운트되지 않았어요.');
  final boundary = ctx.findRenderObject() as RenderRepaintBoundary;
  // 최신 프레임이 그려진 뒤에 캡처되도록 한 프레임 대기 (release-safe).
  await WidgetsBinding.instance.endOfFrame;
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) throw StateError('이미지 인코딩에 실패했어요.');
    return data.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

/// 사진 앨범에 저장. 권한이 없으면 요청한다.
Future<void> saveTalismanToGallery(Uint8List bytes, String name) async {
  final hasAccess = await Gal.hasAccess(toAlbum: true);
  if (!hasAccess) {
    await Gal.requestAccess(toAlbum: true);
  }
  await Gal.putImageBytes(bytes, name: name);
}

/// 임시 파일로 써서 시스템 공유 시트를 연다 (친구·지인에게 선물).
Future<void> shareTalisman(Uint8List bytes, String name, {required String text}) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$name.png');
  await file.writeAsBytes(bytes);
  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path, mimeType: 'image/png')], text: text),
  );
}
