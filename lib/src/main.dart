import 'dart:io';
import 'dart:typed_data';
import 'package:motion_photos/src/helpers.dart';
import 'package:motion_photos/src/video_index.dart';
import 'package:path_provider/path_provider.dart';

///This class is responsible for classifying a file as motion photo,
///if so, extracts the [VideoIndex] from the motion photo.
///extracts the VideoContent of the motion photo.
class MotionPhotos {
  // create a instance of [MotionPhotoHelpers] class
  final helpers = MotionPhotoHelpers();
  late Uint8List buffer;

  ///This Method initializes the [extractor] object
  ///which is responsible for extracting the XMP data
  ///from the motion photo
  MotionPhotos(String filePath) {
    buffer = helpers.pathToBytes(filePath);
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data of the file
  ///returns wheather the file is a motion photo or not
  bool isMotionPhoto() {
    int method = helpers.method(buffer);
    return method != 0;
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data of the file
  ///returns [VideoIndex] of the motion photo
  VideoIndex getMotionVideoIndex() {
    int method = helpers.method(buffer);
    if (method == 1) {
      final val = helpers.extractVideoIndex(helpers.extractXMP(buffer));
      return val;
    } else if (method == 2) {
      final start = helpers.traverseBytes(buffer);
      final val =
          VideoIndex(start, buffer.lengthInBytes, buffer.lengthInBytes - start);
      return val;
    }
    return const VideoIndex(0, 0, 0);
  }

  ///This Method takes [filePath] as parameter
  ///extracts the XMP data and [VideoIndex] of the file
  ///returns [Uint8List] bytes for the video content of
  ///the motion photo
  Uint8List getMotionVideo() {
    final indexes = getMotionVideoIndex();
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
