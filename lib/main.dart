import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_video_info/youtube.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final linkController = TextEditingController(
      text: 'https://www.youtube.com/watch?v=DN0pG_0wUbI');

  String _extractedLink = 'Loading...';
  String youtubeTitle = 'Youtube Video';

  // String youTubeLink = "https://www.youtube.com/watch?v=nRhYQlg8fVw";

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> extractYoutubeLink() async {
    String link;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      link = await FlutterYoutubeDownloader.extractYoutubeLink(
          linkController.text, 18);
    } on PlatformException {
      link = 'Failed to Extract YouTube Video Link.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _extractedLink = link;
    print(_extractedLink);
  }

  Future<void> downloadVideo() async {
    await _getStoragePermission();
    YoutubeDataModel videoData = await YoutubeData.getData(linkController.text);
    print(videoData.title);

    if (videoData.title != null) {
      youtubeTitle = videoData.title!;
    }

    final result = await FlutterYoutubeDownloader.downloadVideo(
        linkController.text, youtubeTitle + '.', 18);
    print(result);
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print('Permission granted');
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      print('Permission denied');
    }
  }

  @override
  void initState() {
    extractYoutubeLink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Youtube Link Downloader example app'),
      ),
      body: Center(
        // child: Text('Extracted Link : $_extractedLink\n'),
        child: Container(
          margin: EdgeInsets.all(15),
          child: TextField(
            controller: linkController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Youtube URL'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: downloadVideo,
        child: const Icon(Icons.download_rounded),
      ),
    );
  }
}
