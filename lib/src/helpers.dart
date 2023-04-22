import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:motion_photos/src/boyermoore_search.dart';
import 'package:motion_photos/src/constants.dart';
import 'package:motion_photos/src/video_index.dart';
import 'package:motion_photos/src/xmp_extractor.dart';

///This class is a helper class which handles all
///the actions required for the motion photo main methods
class MotionPhotoHelpers {
  ///This Method takes [filePath] as parameter
  ///and return [Uint8List] synchronously
  Uint8List pathToBytes(String filePath) {
    if (filePath.isEmpty) throw 'File Path Is Empty';
    File file = File(filePath);
    return file.readAsBytesSync();
  }

  int method(Uint8List buffer) {
    var method1 = false;
    var method2 = false;
    try {
      final xmpData = extractXMP(buffer);
      for (String typeKey in MotionPhotoConstants.fileTypeKeys) {
        if (xmpData.containsKey(typeKey)) {
          method1 = true;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    try {
      final index = traverseBytes(buffer);
      if (index != -1) {
        method2 = true;
      }
    } catch (e) {
      log(e.toString());
    }
    if (method1) return 1;
    if (method2) return 2;
    return 0;
  }

  ///This Method takes [filePath] as parameter
  ///and return [Map] of XMP datas
  Map<String, dynamic> extractXMP(Uint8List bytes) {
    final res = XMPExtractor().extract(bytes);
    res[MotionPhotoConstants.fileSizeKey] = bytes.lengthInBytes.toString();
    return res;
  }

  int traverseBytes(Uint8List buffer) {
    final mp4Pattern = Uint8List.fromList([
      0x00,
      0x00,
      0x00,
      0x18,
      0x66,
      0x74,
      0x79,
      0x70,
      0x6D,
      0x70,
      0x34,
      0x32,
      0x00,
      0x00,
      0x00,
      0x00
    ]);
    final index = boyerMooreSearch(buffer, mp4Pattern);
    return index;
  }

  ///This Method takes [xmpData] as parameter
  ///and return [VideoIndex] of the motion photo
  VideoIndex extractVideoIndex(Map<String, dynamic> xmpData) {
    for (String offSetKey in MotionPhotoConstants.fileOffsetKeys) {
      if (xmpData.containsKey(offSetKey)) {
        final offset = int.parse(xmpData[offSetKey]);
        final size = int.parse(xmpData[MotionPhotoConstants.fileSizeKey]);
        return VideoIndex(size - offset, size, offset);
      }
    }
    throw 'No Video Index Found';
  }
}
