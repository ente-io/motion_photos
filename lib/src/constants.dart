///This class wraps all the constant values used in the Motion Photo Package
class MotionPhotoConstants {
  ///[fileTypeKeys] XMP Key for a File Type
  static List<String> fileTypeKeys = [
    'GCamera:MotionPhoto',
    'GCamera:MicroVideo'
  ];

  ///[fileOffsetKeys] XMP Key for a Motion Photo Video Offset
  static List<String> fileOffsetKeys = [
    'Item:Length',
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
}
