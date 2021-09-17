import 'dart:isolate';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:instagram_public_api/instagram_public_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostDownloader extends StatefulWidget {
  const PostDownloader({Key? key}) : super(key: key);

  @override
  _PostDownloaderState createState() => _PostDownloaderState();
}

class _PostDownloaderState extends State<PostDownloader> {
  ReceivePort _port = ReceivePort();
  final postController = TextEditingController();
  List<InstaPost> posts = [];

  Future _getInstaPosts() async {
    final List<InstaPost> post =
        await FlutterInsta().getPostData(postController.text);
    for (int i = 0; i < post.length; i++) {
      print(post[i].dimensions);
      print(post[i].displayURL); //post download url
      print(post[i].postType);
      print(post[i].thumbnailDimensions);
      print(post[i].thumbnailUrl);
      print(post[i].user.followers);
      print(post[i].user.isPrivate);
      print(post[i].user.isVerified);
      print(post[i].user.posts);
      print(post[i].user.profilePicURL);
      print(post[i].user.username);
      print(post[i].videoDuration);
      downloadPosts(post[i].displayURL ?? '');
    }
  }

  @override
  void initState() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        postController.text = value;
      });
    });

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
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
              controller: postController,
              decoration: InputDecoration(
                  hintText: "Paste your link here...",
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                  ),
                  suffixIcon: GestureDetector(
                      onTap: () => postController.clear(),
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
                          postController.text = value;
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
                    await _getInstaPosts();
                  },
                  child: Text("Download Posts"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Download reel video on button clickl
  downloadPosts(String url) async {
    if (await Permission.storage.request().isGranted) {
      print('Permission granted');

      final baseStorage = await getExternalStorageDirectory();

      print(baseStorage!.path);

      await FlutterDownloader.enqueue(
        url: '$url',
        savedDir: baseStorage.path,
        fileName: DateTime.now().millisecondsSinceEpoch.toString() + '.jpg',
        showNotification: true,
        openFileFromNotification: true,
      ).whenComplete(() {});
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      print('Permission denied');
    }
  }
}
