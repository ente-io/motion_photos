///[VideoIndex] is the model class used fo storing
/// MotionPhotos start and end index with file size
class VideoIndex {
  ///[start] is the starting index of video content in motion photo buffer.
  final int start;

  ///[end] is the ending index of video content in motion photo buffer.
  final int end;

  int get videoLength => end - start;

  const VideoIndex({
    required this.start,
    required this.end,
  });

  @override
  String toString() =>
      'VideoIndex{start: $start, end: $end, videoLength: $videoLength}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoIndex &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          videoLength == other.videoLength;

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ videoLength.hashCode;
}
