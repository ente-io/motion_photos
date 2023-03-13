import 'dart:io';
import 'dart:typed_data';

import 'package:motion_photos/src/constants.dart';
import 'package:motion_photos/src/helpers.dart';
import 'package:motion_photos/src/video_index.dart';
import 'package:path_provider/path_provider.dart';

///This class is responsible for classifying a file as motion photo,
///if so, extracts the [VideoIndex] from the motion photo.
///extracts the VideoContent of the motion photo.
class MotionPhotos {
  // create a instance of [MotionPhotoHelpers] class
  final helpers = MotionPhotoHelpers();

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data of the file
  ///returns wheather the file is a motion photo or not
  bool isMotionPhoto(String filePath) {
    final xmpData = helpers.extractXMP(filePath);
    return xmpData.containsValue(MotionPhotoConstants.motionPhoto);
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data of the file
  ///returns [VideoIndex] of the motion photo
  VideoIndex getMotionVideoIndex(String filePath) =>
      helpers.extractVideoIndex(helpers.extractXMP(filePath));

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data and [VideoIndex] of the file
  ///returns [Uint8List] bytes for the video content of
  ///the motion photo
  Uint8List getMotionVideo(String filePath) {
    final indexes = getMotionVideoIndex(filePath);
    return helpers
        .pathToBytes(filePath)
        .buffer
        .asUint8List(indexes.startIndex, indexes.videoLength);
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data and [VideoIndex] of the file
  ///returns [File] containing the video portion of the
  ///motion photo in MP4 format
  Future<File> getMotionVideoFile(String filePath,
      {String fileName = 'motionphoto'}) async {
    Directory tempDir = await getTemporaryDirectory();
    return File('${tempDir.path}/$fileName.mp4')
        .writeAsBytes(getMotionVideo(filePath));
  }
}
