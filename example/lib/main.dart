import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:motion_photos/motion_photos.dart';
import 'package:path_provider/path_provider.dart';
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
      title: 'Motion Photo Example (from ente.io team)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Motion Photo Example'),
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
  late String directory;
  List file = List.empty(growable: true);
  late VideoPlayerController _controller;
  late MotionPhotos motionPhotos;
  bool? _isMotionPhoto;
  VideoIndex? videoIndex;
  bool isPicked = false;

  Future<void> _pickFromGallery() async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowCompression: false,
      );
      // reset video index
      videoIndex = null;
      _isMotionPhoto = null;
      final path = result!.paths[0]!;
      motionPhotos = MotionPhotos(path);
      _isMotionPhoto = await motionPhotos.isMotionPhoto();
      if (_isMotionPhoto!) {
        videoIndex = await motionPhotos.getMotionVideoIndex();
      }
      setState(() {
        isPicked = true;
      });
    } catch (e) {
      log('Exep: ****$e***');
    }
  }

  Future<Widget> _playVideo() async {
    if (isPicked && (_isMotionPhoto ?? false)) {
      try {
        File file = await motionPhotos
            .getMotionVideoFile(await getTemporaryDirectory());
        _controller = VideoPlayerController.file(file);
        _controller.initialize();
        _controller.setLooping(true);
        _controller.play();
        return VideoPlayer(_controller);
      } catch (e) {
        return Text(e.toString(), style: const TextStyle(color: Colors.red));
      }
    }
    return const SizedBox.shrink();
  }

  String printIsMotionPhoto() {
    if (isPicked && _isMotionPhoto != null) {
      return _isMotionPhoto! ? 'Yes' : 'No';
    }
    return 'TBA';
  }

  String printVideoIndex() {
    if (isPicked && videoIndex != null) {
      return '''
      Start Index: ${videoIndex!.start}
      End Index: ${videoIndex!.end}
      Video Size: ${videoIndex!.videoLength}
    ''';
    }
    return 'NA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Is MotionPhoto: ${printIsMotionPhoto()}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          const Text('Video Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(printVideoIndex()),
          const SizedBox(height: 20),
          Container(
            color: Colors.transparent,
            width: double.infinity,
            height: 300,
            child: FutureBuilder<Widget>(
              future: _playVideo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pickFromGallery();
        },
        child: const Icon(Icons.image),
      ),
    );
  }
}
