import 'dart:io';
import 'dart:typed_data';

import 'package:motion_photos/src/boyermoore_search.dart';
import 'package:motion_photos/src/helpers.dart';
import 'package:motion_photos/src/video_index.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';

///This class is responsible for classifying a file as motion photo,
///if so, extracts the [VideoIndex] from the motion photo.
///extracts the VideoContent of the motion photo.
class MotionPhotos {
  late Uint8List buffer;

  ///This Method initializes the [extractor] object
  ///which is responsible for extracting the XMP data
  ///from the motion photo
  MotionPhotos(String filePath) {
    buffer = MotionPhotoHelpers.pathToBytes(filePath);
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data of the file
  ///returns wheather the file is a motion photo or not
  bool isMotionPhoto() {
    int method = MotionPhotoHelpers.method(buffer);
    return method != 0;
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data of the file
  ///returns [VideoIndex] of the motion photo
  VideoIndex? getMotionVideoIndex() {
    final int mp4Index =
        boyerMooreSearch(buffer, MotionPhotoConstants.mp4HeaderPattern);
    if (mp4Index != -1) {
      return VideoIndex(
          mp4Index, buffer.lengthInBytes, buffer.lengthInBytes - mp4Index);
    }

    return MotionPhotoHelpers.extractVideoIndexFromXMP(buffer);
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data and [VideoIndex] of the file
  ///returns [Uint8List] bytes for the video content of
  ///the motion photo
  Uint8List getMotionVideo() {
    final indexes = getMotionVideoIndex()!;
    return buffer.buffer.asUint8List(indexes.startIndex, indexes.videoLength);
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data and [VideoIndex] of the file
  ///returns [File] containing the video portion of the
  ///motion photo in MP4 format
  Future<File> getMotionVideoFile({String fileName = 'motionphoto'}) async {
    Directory tempDir = await getTemporaryDirectory();
    return File('${tempDir.path}/$fileName.mp4').writeAsBytes(getMotionVideo());
  }
}
