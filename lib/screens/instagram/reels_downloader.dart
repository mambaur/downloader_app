import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ReelsDownloader extends StatefulWidget {
  const ReelsDownloader({Key? key}) : super(key: key);

  @override
  _ReelsDownloaderState createState() => _ReelsDownloaderState();
}

class _ReelsDownloaderState extends State<ReelsDownloader> {
  FlutterInsta flutterInsta = FlutterInsta();
  ReceivePort _port = ReceivePort();
  TextEditingController reelController =
      TextEditingController(text: 'https://www.instagram.com/p/CDlGkdZgB2y');
  int progress = 0;
  bool downloading = false;

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            controller: reelController,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                downloading = true; //set to true to show Progress indicator
              });
              await downloadReels();
            },
            child: Text("Download Reels"),
          ),
          downloading
              ? Center(
                  child:
                      CircularProgressIndicator(), //if downloading is true show Progress Indicator
                )
              : Container()
        ],
      ),
    );
  }

  //Download reel video on button click
  downloadReels() async {
    var myvideourl = await flutterInsta.downloadReels(reelController.text);

    if (await Permission.storage.request().isGranted) {
      print('Permission granted');

      final baseStorage = await getExternalStorageDirectory();

      print(baseStorage!.path);

      await FlutterDownloader.enqueue(
        url: '$myvideourl',
        savedDir: baseStorage.path,
        fileName: DateTime.now().millisecondsSinceEpoch.toString() + '.mp4',
        showNotification: true,
        openFileFromNotification: true,
      ).whenComplete(() {
        setState(() {
          downloading = false; // set to false to stop Progress indicator
        });
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      print('Permission denied');
    }
  }
}
