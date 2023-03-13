///[VideoIndex] is the model class used fo storing
/// MotionPhotos start and end index with file size
class VideoIndex {
  ///[startIndex] is the starting index of video content in motion photo buffer.
  final int startIndex;

  ///[endIndex] is the ending index of video content in motion photo buffer.
  final int endIndex;

  ///[endIndex] is the size of video content in motion photo buffer.
  final int videoLength;

  const VideoIndex(this.startIndex, this.endIndex, this.videoLength);
}
