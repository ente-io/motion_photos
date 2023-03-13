import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_photos/motion_photos.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotionPhotos Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'MotionPhotos Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _path = '';
  late String directory;
  List file = List.empty(growable: true);
  late VideoPlayerController _controller;

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _path = imageFile!.path;
    });
  }

  Future<Widget> _playVideo() async {
    if (_path.isNotEmpty) {
      try {
        File file = await MotionPhotos().getMotionVideoFile(_path);
        _controller = VideoPlayerController.file(file);
        _controller.initialize();
        _controller.setLooping(true);
        _controller.play();
        return VideoPlayer(_controller);
      } catch (e) {
        Text(e.toString(), style: const TextStyle(color: Colors.white));
      }
    }
    return const Icon(Icons.play_arrow, size: 45, color: Colors.white);
  }

  String printIsMotionPhoto() {
    try {
      final isMotionPhoto = MotionPhotos().isMotionPhoto(_path);
      return isMotionPhoto.toString();
    } catch (e) {
      return e.toString();
    }
  }

  String printVideoIndex() {
    try {
      final vidIndex = MotionPhotos().getMotionVideoIndex(_path);
      return '''
    Start Index: ${vidIndex.startIndex}
    End Index: ${vidIndex.endIndex}
    Video Size: ${vidIndex.videoLength}
    ''';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "IsMotionPhoto"),
                Tab(text: "VideoIndex"),
                Tab(text: "MotionPhotoVideo"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                  child: Text(
                'Is MotionPhoto: ${_path.isEmpty ? false : printIsMotionPhoto()}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              )),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const Text('MotionPhoto VideoIndex',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    Text(_path.isEmpty ? '' : printVideoIndex()),
                  ])),
              Center(
                child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 300,
                    child: FutureBuilder<Widget>(
                        future: _playVideo(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _pickFromGallery();
            },
            child: const Icon(Icons.image),
          ),
        ));
  }
}
