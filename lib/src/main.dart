import 'dart:io';
import 'dart:typed_data';

import 'package:motion_photos/src/boyermoore_search.dart';
import 'package:motion_photos/src/constants.dart';
import 'package:motion_photos/src/helpers.dart';
import 'package:motion_photos/src/video_index.dart';
import 'package:path_provider/path_provider.dart';

///This class is responsible for classifying a file as motion photo,
///if so, extracts the [VideoIndex] from the motion photo.
///extracts the VideoContent of the motion photo.
class MotionPhotos {
  final String filePath;
  bool bufferLoaded = false;
  late Uint8List _buffer;

  MotionPhotos(this.filePath);

  void loadBuffer() {
    if (!bufferLoaded) {
      _buffer = MotionPhotoHelpers.pathToBytes(filePath);
      bufferLoaded = true;
    }
  }

  /// isMotionPhoto returns true if the file is a motion photo
  bool isMotionPhoto() {
    try {
      loadBuffer();
      return getMotionVideoIndex() != null;
    } catch (e) {
      return false;
    }
  }

  // getMotionVideoIndex returns the [VideoIndex] of the photo if it's a motion photo
  // otherwise returns null
  VideoIndex? getMotionVideoIndex() {
    loadBuffer();
    // Note: The order of the following methods is important
    // We need to check for MP4 header, then XMP.
    final int mp4Index =
        boyerMooreSearch(_buffer, MotionPhotoConstants.mp4HeaderPattern);
    if (mp4Index != -1) {
      return VideoIndex(start: mp4Index, end: _buffer.lengthInBytes);
    }
    return MotionPhotoHelpers.extractVideoIndexFromXMP(_buffer);
  }

  // getMotionVideo returns the video portion of the motion photo.
  // If [index] is not provided, it will be extracted from the file at given {filePath}.
  Uint8List getMotionVideo({VideoIndex? index}) {
    final videoIndex = index ?? getMotionVideoIndex();
    if (videoIndex == null) {
      throw Exception('unable to find video index');
    }
    return _buffer.buffer.asUint8List(videoIndex.start, videoIndex.videoLength);
  }

  // getMotionVideoFile returns the video portion of the motion photo as a file.
  Future<File> getMotionVideoFile({
    String fileName = 'motionphoto',
    VideoIndex? index,
  }) async {
    loadBuffer();
    Directory tempDir = await getTemporaryDirectory();
    return File('${tempDir.path}/$fileName.mp4').writeAsBytes(
      getMotionVideo(index: index),
    );
  }
}
