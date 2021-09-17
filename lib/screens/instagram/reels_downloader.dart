import 'dart:isolate';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  @override
  void initState() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        reelController.text = value;
      });
    });

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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5)),
            child: TextField(
              controller: reelController,
              decoration: InputDecoration(
                  hintText: "Paste your link here...",
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                  ),
                  suffixIcon: GestureDetector(
                      onTap: () => reelController.clear(),
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
                          reelController.text = value;
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
                  onPressed: () async {
                    await downloadReels();
                  },
                  child: Text("Download Reels"),
                ),
              ),
            ],
          ),
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
        // do something
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      print('Permission denied');
    }
  }
}
