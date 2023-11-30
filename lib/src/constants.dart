import 'dart:typed_data';

///This class wraps all the constant values used in the Motion Photo Package
class MotionPhotoConstants {
  ///[fileTypeKeys] XMP Key for a File Type
  static List<String> fileTypeKeys = [
    'GCamera:MotionPhoto',
    'GCamera:MicroVideo'
  ];

  static String itemLengthOffsetKey = 'Item:Length';
  static String GCameraMotionPhoto = 'GCamera:MotionPhoto';
  static String ItemMimeType = 'Item:MimeType';

  ///[fileOffsetKeys] XMP Key for a Motion Photo Video Offset
  static List<String> fileOffsetKeys = [
    itemLengthOffsetKey,
    'GCamera:MicroVideoOffset'
  ];

  ///[fileTypeKey] XMP Key for a Motion Photo Video Size
  static String fileSizeKey = 'Item:Size';

  ///[motionPhoto] XMP Value for a File of Type Motion Photo
  static String motionPhoto = 'MotionPhoto';

  ///[markerBegin] XMP Opening Tag
  static String markerBegin = '<x:xmpmeta';

  ///[markerEnd] XMP Closing Tag
  static String markerEnd = '</x:xmpmeta>';

  // MP4 file header pattern with 'mp42' as the major brand
  static Uint8List mp4HeaderPattern = Uint8List.fromList([
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
}
