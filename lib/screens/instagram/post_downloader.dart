import 'dart:isolate';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:instagram_public_api/instagram_public_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    posts = [];
    EasyLoading.show(status: 'loading...', dismissOnTap: true);
    try {
      posts = await FlutterInsta().getPostData(postController.text);
      for (int i = 0; i < posts.length; i++) {
        // print(posts[i].dimensions);
        // print(posts[i].displayURL); //post download url
        // print(posts[i].postType);
        // print(posts[i].thumbnailDimensions);
        // print(posts[i].thumbnailUrl);
        // print(posts[i].user.followers);
        // print(posts[i].user.isPrivate);
        // print(posts[i].user.isVerified);
        // print(posts[i].user.posts);
        // print(posts[i].user.profilePicURL);
        // print(posts[i].user.username);
        // print(posts[i].videoDuration);

        String? fileName;
        if (posts[i].postType! == PostType.GraphImage) {
          fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        } else if (posts[i].postType! == PostType.GraphVideo) {
          fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.mp4';
        }

        print(fileName);

        await downloadPosts(posts[i].displayURL ?? '', fileName);
      }
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Download Success');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Your link is invalid');
      EasyLoading.dismiss();
    }

    setState(() {});
  }

  @override
  void initState() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;

    FlutterClipboard.paste().then((value) {
      if (value != '') {
        try {
          final uri = Uri.parse(value);
          if (uri.host == 'www.instagram.com') {
            setState(() {
              postController.text = value;
            });
          }
        } catch (e) {
          print('No url on clipboard');
        }
      }
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
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
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
              minLines: 1,
              maxLines: 1,
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
                  child: Text("Download"),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            spreadRadius: 0)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.25,
                        height: size.width * 0.25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: posts[index].thumbnailUrl!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: size.width * 0.08,
                                    height: size.width * 0.08,
                                    margin: EdgeInsets.only(right: 10),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          posts[index].user.profilePicURL!),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(posts[index].user.username!)
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: size.width * 0.08,
                                    height: size.width * 0.08,
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [Text('Download success')],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  //Download reel video on button clickl
  downloadPosts(String url, String? fileName) async {
    if (await Permission.storage.request().isGranted) {
      print('Permission granted');

      final baseStorage = await getExternalStorageDirectory();

      print(baseStorage!.path);

      await FlutterDownloader.enqueue(
        url: '$url',
        savedDir: baseStorage.path,
        fileName: fileName ?? DateTime.now().millisecondsSinceEpoch.toString(),
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
