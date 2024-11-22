import 'dart:developer';
import 'dart:typed_data';

import 'package:motion_photos/src/constants.dart';
import 'package:motion_photos/src/video_index.dart';
import 'package:motion_photos/src/xmp_extractor.dart';

///This class is a helper class which handles all
///the actions required for the motion photo main methods
class MotionPhotoHelpers {
  ///extractVideoIndexFromXMP takes file [bytes] as parameter
  /// and return [VideoIndex] of the motion photo using the XMP data
  static VideoIndex? extractVideoIndexFromXMP(Uint8List bytes) {
    try {
      final Map<String, dynamic> xmpData = XMPExtractor().extract(bytes);
      final int size = bytes.lengthInBytes;
      for (String offSetKey in MotionPhotoConstants.fileOffsetKeys) {
        if (xmpData.containsKey(offSetKey)) {
          final offsetFromEnd = int.parse(xmpData[offSetKey]);
          if (offSetKey == MotionPhotoConstants.itemLengthOffsetKey) {
            if (offsetFromEnd + offsetFromEnd < size &&
                !hasMotionPhotoTags(xmpData)) {
              log('Found ${MotionPhotoConstants.itemLengthOffsetKey} but video length looks invalid');
              continue;
            }
          }
          return VideoIndex(start: size - offsetFromEnd, end: size);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static bool hasMotionPhotoTags(Map<String, dynamic> xmpData) {
    if (xmpData.containsKey(MotionPhotoConstants.gCameraMotionPhoto)) {
      return true;
    }
    if (xmpData.containsKey(MotionPhotoConstants.itemMimeType)) {
      return xmpData[MotionPhotoConstants.itemMimeType]
          .toString()
          .startsWith('video');
    }
    return false;
  }
}
