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
  static Uint8List pathToBytes(String filePath) {
    if (filePath.isEmpty) throw 'File Path Is Empty';
    File file = File(filePath);
    return file.readAsBytesSync();
  }

  static int method(Uint8List buffer) {
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

    if (method2) return 2;
    if (method1) return 1;

    return 0;
  }

  ///This Method takes [filePath] as parameter
  ///and return [Map] of XMP datas
  static Map<String, dynamic> extractXMP(Uint8List bytes) {
    final res = XMPExtractor().extract(bytes);
    res[MotionPhotoConstants.fileSizeKey] = bytes.lengthInBytes.toString();
    return res;
  }

  static int traverseBytes(Uint8List buffer) =>
      boyerMooreSearch(buffer, MotionPhotoConstants.mp4HeaderPattern);

  ///extractVideoIndexFromXMP takes file [bytes] as parameter
  /// and return [VideoIndex] of the motion photo using the XMP data
  static VideoIndex? extractVideoIndexFromXMP(Uint8List bytes) {
    try {
      final Map<String, dynamic> xmpData = XMPExtractor().extract(bytes);
      final int size = bytes.lengthInBytes;
      for (String offSetKey in MotionPhotoConstants.fileOffsetKeys) {
        if (xmpData.containsKey(offSetKey)) {
          final offset = int.parse(xmpData[offSetKey]);
          return VideoIndex(size - offset, size, offset);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
