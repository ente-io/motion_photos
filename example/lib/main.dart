import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  late String directory;
  List file = List.empty(growable: true);
  late VideoPlayerController _controller;
  late MotionPhotos motionPhotos;
  bool isPicked = false;

  Future<void> _pickFromGallery() async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      final path = result!.paths[0]!;
      motionPhotos = MotionPhotos(path);
      setState(() {
        isPicked = true;
      });
    } catch (e) {
      log('Exep: ****$e***');
    }
  }

  Future<Widget> _playVideo() async {
    if (isPicked) {
      try {
        File file = await motionPhotos.getMotionVideoFile();
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
    if (isPicked) {
      try {
        final isMotionPhoto = motionPhotos.isMotionPhoto();
        return isMotionPhoto.toString();
      } catch (e) {
        return e.toString();
      }
    }
    return 'TBA';
  }

  String printVideoIndex() {
    if (isPicked) {
      try {
        final vidIndex = motionPhotos.getMotionVideoIndex();
        return '''
    Start Index: ${vidIndex.startIndex}
    End Index: ${vidIndex.endIndex}
    Video Size: ${vidIndex.videoLength}
    ''';
      } catch (e) {
        return e.toString();
      }
    }
    return 'TBA';
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
                'Is MotionPhoto: ${printIsMotionPhoto()}',
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
                    Text(printVideoIndex()),
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
