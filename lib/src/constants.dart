///This class wraps all the constant values used in the Motion Photo Package
class MotionPhotoConstants {
  ///[fileTypeKey] XMP Key for a File Type
  static String fileTypeKey = 'Item:Semantic';

  ///[fileTypeKey] XMP Key for a Motion Photo Video Size
  static String fileSizeKey = 'Item:Size';

  ///[fileOffsetKey] XMP Key for a Motion Photo Video Offset
  static String fileOffsetKey = 'Item:Length';

  ///[motionPhoto] XMP Value for a File of Type Motion Photo
  static String motionPhoto = 'MotionPhoto';

  ///[markerBegin] XMP Opening Tag
  static String markerBegin = '<x:xmpmeta';

  ///[markerEnd] XMP Closing Tag
  static String markerEnd = '</x:xmpmeta>';
}
