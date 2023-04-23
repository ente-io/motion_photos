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

  @override
  String toString() =>
      'Result{startIndex: $startIndex, endIndex: $endIndex, videoLength: $videoLength}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoIndex &&
          runtimeType == other.runtimeType &&
          startIndex == other.startIndex &&
          endIndex == other.endIndex &&
          videoLength == other.videoLength;

  @override
  int get hashCode =>
      startIndex.hashCode ^ endIndex.hashCode ^ videoLength.hashCode;
}
