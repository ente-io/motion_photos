import 'dart:io';
import 'dart:typed_data';

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

  ///This Method takes [filePath] as parameter
  ///and return [Map] of XMP datas
  Map<String, dynamic> extractXMP(String filePath) {
    final bytes = pathToBytes(filePath);
    final res = XMPExtractor().extract(bytes);
    res[MotionPhotoConstants.fileSizeKey] = bytes.lengthInBytes.toString();
    return res;
  }

  ///This Method takes [xmpData] as parameter
  ///and return [VideoIndex] of the motion photo
  VideoIndex extractVideoIndex(Map<String, dynamic> xmpData) {
    if (xmpData.containsKey(MotionPhotoConstants.fileOffsetKey)) {
      final offset = int.parse(xmpData[MotionPhotoConstants.fileOffsetKey]);
      final size = int.parse(xmpData[MotionPhotoConstants.fileSizeKey]);
      return VideoIndex(size - offset, size, offset);
    } else {
      throw 'No Video Index Found';
    }
  }
}
