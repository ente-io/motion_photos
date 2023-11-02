import 'package:flutter_test/flutter_test.dart';
import 'package:motion_photos/motion_photos.dart';
import 'package:motion_photos/src/boyermoore_search.dart';
import 'package:motion_photos/src/constants.dart';

void main() {
  group('isMotionPhoto', () {
    test('JPEG MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.jpg');
      expect(await motionPhotos.isMotionPhoto(), true);
    });

    test('HEIF MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.heic');
      expect(await motionPhotos.isMotionPhoto(), true);
    });

    test('Not a MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/normalphoto.jpg');
      expect(await motionPhotos.isMotionPhoto(), false);
    });

    test('Not a MotionPhoto (Pixel8)', () async {
      final motionPhotos = MotionPhotos('assets/pixel_8.jpg');
      expect(await motionPhotos.isMotionPhoto(), false);
    });
  });

  group('getVideoIndex', () {
    test('JPEG MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.jpg');
      final actualResult = await motionPhotos.getMotionVideoIndex();
      const expectedResult = VideoIndex(start: 3366251, end: 8013982);
      expect(actualResult!, expectedResult);
    });

    test('HEIF MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.heic');
      final actualResult = await motionPhotos.getMotionVideoIndex();
      const expectedResult = VideoIndex(start: 1455411, end: 3649069);
      expect(actualResult!, expectedResult);
    });

    test('Not a motion photo_pixel', () async {
      final motionPhotos = MotionPhotos('assets/normalphoto.jpg');
      final actualResult = await motionPhotos.getMotionVideoIndex();
      expect(actualResult == null, true);
    });
  });

  group('getMotionVideo', () {
    test('JPEG MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.jpg');
      final videoBuffer = await motionPhotos.getMotionVideo();
      final hasVideoContent = boyerMooreSearch(
              videoBuffer, MotionPhotoConstants.mp4HeaderPattern) !=
          -1;
      expect(hasVideoContent, true);
    });

    test('HEIF MotionPhoto', () async {
      final motionPhotos = MotionPhotos('assets/motionphoto.heic');
      final videoBuffer = await motionPhotos.getMotionVideo();
      final hasVideoContent = boyerMooreSearch(
              videoBuffer, MotionPhotoConstants.mp4HeaderPattern) !=
          -1;
      expect(hasVideoContent, true);
    });
  });
}
