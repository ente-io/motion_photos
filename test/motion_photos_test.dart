import 'package:flutter_test/flutter_test.dart';
import 'package:motion_photos/motion_photos.dart';
import 'package:motion_photos/src/video_index.dart';

void main() {
  group('isMotionPhoto', () {
    test('JPEG MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.jpg');
      expect(motionPhotos.isMotionPhoto(), true);
    });

    test('HEIF MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.heic');
      expect(motionPhotos.isMotionPhoto(), true);
    });

    test('Not a MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/normalphoto.jpg');
      expect(motionPhotos.isMotionPhoto(), false);
    });
  });

  group('getVideoIndex', () {
    test('JPEG MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.jpg');
      final actualResult = motionPhotos.getMotionVideoIndex();
      const expectedResult = VideoIndex(3366251, 8013982, 4647731);
      expect(actualResult, expectedResult);
    });

    test('HEIF MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.heic');
      final actualResult = motionPhotos.getMotionVideoIndex();
      const expectedResult = VideoIndex(1455411, 3649069, 2193658);
      expect(actualResult, expectedResult);
    });

    test('Not a MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/normalphoto.jpg');
      final actualResult = motionPhotos.getMotionVideoIndex();
      const expectedResult = VideoIndex(0, 0, 0);
      expect(actualResult, expectedResult);
    });
  });

  group('getMotionVideo', () {
    test('JPEG MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.jpg');
      final videoBuffer = motionPhotos.getMotionVideo();
      final hasVideoContent =
          motionPhotos.helpers.traverseBytes(videoBuffer) != -1;
      expect(hasVideoContent, true);
    });

    test('HEIF MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.heic');
      final videoBuffer = motionPhotos.getMotionVideo();
      final hasVideoContent =
          motionPhotos.helpers.traverseBytes(videoBuffer) != -1;
      expect(hasVideoContent, true);
    });

    test('Not a MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/normalphoto.jpg');
      final videoBuffer = motionPhotos.getMotionVideo();
      final hasVideoContent =
          motionPhotos.helpers.traverseBytes(videoBuffer) != -1;
      expect(hasVideoContent, false);
    });
  });
}
