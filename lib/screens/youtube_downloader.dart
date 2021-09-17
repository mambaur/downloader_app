import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_video_info/youtube.dart';

class YoutubeDownloader extends StatefulWidget {
  YoutubeDownloader({Key? key}) : super(key: key);

  @override
  _YoutubeDownloaderState createState() => _YoutubeDownloaderState();
}

class _YoutubeDownloaderState extends State<YoutubeDownloader> {
  final linkController = TextEditingController(
      text: 'https://www.youtube.com/watch?v=DN0pG_0wUbI');

  String _extractedLink = 'Loading...';
  String youtubeTitle = 'Youtube Video';

  // String youTubeLink = "https://www.youtube.com/watch?v=nRhYQlg8fVw";

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> extractYoutubeLink() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _extractedLink = await FlutterYoutubeDownloader.extractYoutubeLink(
          linkController.text, 18);
    } on PlatformException {
      _extractedLink = 'Failed to Extract YouTube Video Link.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // print(_extractedLink);
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
    FlutterClipboard.paste().then((value) {
      setState(() {
        linkController.text = value;
      });
    });

    extractYoutubeLink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Text('Extracted Link : $_extractedLink\n'),
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: linkController,
                  decoration: InputDecoration(
                      hintText: "Paste your link here...",
                      suffixIconConstraints: BoxConstraints(
                        minWidth: 25,
                        minHeight: 25,
                      ),
                      suffixIcon: GestureDetector(
                          onTap: () => linkController.clear(),
                          child: Icon(Icons.close)),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          onPrimary: Theme.of(context).primaryColor,
                          primary: Colors.grey.shade200,
                          elevation: 0),
                      onPressed: () async {
                        FlutterClipboard.paste().then((value) {
                          if (value == '') {
                            Fluttertoast.showToast(msg: 'No link detected');
                          } else {
                            setState(() {
                              linkController.text = value;
                            });
                          }
                        });
                      },
                      child: Text(
                        "Paste Link",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 0),
                      onPressed: downloadVideo,
                      child: Text("Download"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
