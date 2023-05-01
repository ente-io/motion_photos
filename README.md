# motion_photo
The Flutter [MotionPhoto](https://support.google.com/googlecamera/answer/9937175?hl=en) Package to detect and extract the video content from the motion photos by [ente](https://ente.io).

## Features

* `IsMotionPhoto` method detects if the give file is MotionPhoto or Not.

* `getMotionVideoIndex` method extracts the start and end Index of the MotionPhoto.

* `getMotionVideo` method returns [Uint8List] bytes for the video content of the motion photo.

* `getMotionVideo` method extracts and returns mp4 file of the video content of the motion photo.

## Getting started

To use this package:
* Run the following command in terminal
  * ```
    flutter pub get motion_photo
    ```
    OR
* Add the following in pubspec.yaml file
  * ```yml
    dependencies:
        flutter:
            sdk: flutter
        motion_photo:   
     ```

## Usage

**MotionPhotos Example App:**
* Video

    https://user-images.githubusercontent.com/63253383/224796252-c671f465-be88-49df-9bd1-ab51984ac94c.mp4

* Clone the codebase.
    ```sh
    git clone <REPO_URL>
    ```
* Go to example folder.
    ```sh
    cd /example
    ```
* Run the App.
    ```sh
    flutter run
    ```
* Code
    ```dart
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
          type: FileType.image,
          allowMultiple: false,
          allowCompression: false,
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
    ```
## DataTypes Descriptions

  Types                |   Fields            | 
--------------------   | ------------------  | 
`VideoIndex`  | <p>**int** `start` [start index of video in buffer]</p> <p>**int** `end` [end index of video in buffer]</p>  <p>**int** `videoLength` [length of the video in buffer] </p>  |

## Method Descriptions

  Methods                |   Parameters                       |   Return
-----------------------  | -------------------------------    | ---------------
`isMotionPhoto`          |   <p>**String** `filePath` [path of the file]                                 |  **bool**                                      | 
`getMotionVideoIndex`  | <p>**String** `filePath` [path of the file]</p>  | **VideoIndex** 
`getMotionVideo`  | <p>**String** `filePath` [path of the file]  | **Uint8List**
`getMotionVideoFile`  | <p>**String** `filePath` [path of the file]</p><p>**String** `fileName` [optional fileName for the destination mp4 file]</p>   | **Future\<File>**

## Implementation

A Motion Photo file consists of two parts, a still image and video. Usually, the image is at the start of the file and the video is towards the end. Usually named as `IMG_XXXX_XXXX_MP.jpeg`

We use two methods to detect and extract motionphoto details:

* Reads the XMP data of the File to detect whether it is a motion photo and also extracts the video offset to process and retrive the video content of the File in a mp4 format.

* Traverses the bytes in the File and checks if it contains a mp4 pattern header using boyermoore_search algorithm and also extracts the video offset to process and retrive the video content of the File in a mp4 format.(This is useful in detecting heif file formats).


