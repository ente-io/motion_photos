# motion_photos
The Flutter [MotionPhotos](https://pub.dev/packages/motion_photos) Package to detect and extract the video content from the motion photos by [ente](https://ente.io).

**Related Blog** [How to detect Android motion photos in Flutter](https://ente.io/blog/tech/android-motion-photos-flutter/)

## Features

* `IsMotionPhoto` method detects if the give file is MotionPhoto or Not.

* `getMotionVideoIndex` method extracts the start and end Index of the MotionPhoto.

* `getMotionVideo` method returns [Uint8List] bytes for the video content of the motion photo.

* `getMotionVideoFile` method extracts and returns mp4 file of the video content of the motion photo.

## Getting started

To use this package:
* Add dependency to your [pubspec.yaml](https://flutter.dev/docs/development/packages-and-plugins/using-packages) file either by directly adding the dependency or by using terminal.
   - Via Terminal
  ```
  flutter pub get motion_photos
  ```
  - Or Add the following in pubspec.yaml file
  ```yml
  dependencies:
      flutter:
          sdk: flutter
      motion_photos:
   ```

## Usage

**MotionPhotos Example App:**

* Clone the codebase.
    ```sh
    git clone git@github.com:ente-io/motion_photos.git
    ```
* Go to example folder.
    ```sh
    cd ./example
    ```
* Run the App.
    ```sh
    flutter run
    ```
* Code
    ```dart
  import 'dart:developer';
  import 'dart:io';
  
  import 'package:file_picker/file_picker.dart';
  import 'package:flutter/material.dart';
  import 'package:motion_photos/motion_photos.dart';
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
          File file = await motionPhotos.getMotionVideoFile();
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
    
    ```
## DataTypes Descriptions

  Types                |   Fields            | 
--------------------   | ------------------  | 
`VideoIndex`  | <p>**int** `start` [start index of video in buffer]</p> <p>**int** `end` [end index of video in buffer]</p>  <p>**int** `videoLength` [length of the video in buffer] </p>  |

## Method Descriptions

  Methods                |   Parameters                       |   Return
-----------------------  | -------------------------------    | ---------------
`isMotionPhoto`          |   <p>**String** `filePath` [path of the file]                                 |  **Future\<bool>**                                      | 
`getMotionVideoIndex`  | <p>**String** `filePath` [path of the file]</p>  | **Future\<VideoIndex?>** 
`getMotionVideo`  | <p>**String** `filePath` [path of the file]  | **Future\<Uint8List>**
`getMotionVideoFile`  | <p>**String** `filePath` [path of the file]</p><p>**String** `fileName` [optional fileName for the destination mp4 file]</p>   | **Future\<File>**

## Implementation

A Motion Photo file consists of two parts, a still image and video. Usually, the image is at the start of the file and the video is towards the end. Usually named as `IMG_XXXX_XXXX_MP.jpeg`

We use two methods to detect and extract motionphoto details:

* Reads the XMP data of the File to detect whether it is a motion photo and also extracts the video offset to process and retrive the video content of the File in a mp4 format.

* Traverses the bytes in the File and checks if it contains a mp4 pattern header using boyermoore_search algorithm and also extracts the video offset to process and retrive the video content of the File in a mp4 format.(This is useful in detecting heif file formats).


