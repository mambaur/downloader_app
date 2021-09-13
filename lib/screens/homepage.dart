import 'dart:isolate';
import 'dart:ui';

import 'package:downloader/screens/youtube_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterInsta flutterInsta = FlutterInsta();
  ReceivePort _port = ReceivePort();
  TextEditingController usernameController = TextEditingController();
  TextEditingController reelController =
      TextEditingController(text: 'https://www.instagram.com/p/CDlGkdZgB2y');
  int currentTab = 0;
  int progress = 0;
  bool downloading = false;

  final List<Widget> screens = [
    Center(
      child: Text('Index 0'),
    ),
    YoutubeDownloader(),
    Center(
      child: Text('Index 2'),
    ),
    Center(
      child: Text('Index 3'),
    ),
  ];

  downloadReels() async {
    var reels = await flutterInsta
        .downloadReels("https://www.instagram.com/p/CDlGkdZgB2y");
    print(reels);
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget? currentScreen;

  @override
  void initState() {
    currentScreen = reelPage();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // String id = data[0];
      // DownloadTaskStatus status = data[1];
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloader Social'),
        elevation: 0,
        centerTitle: true,
      ),
      body: PageStorage(
        child: currentScreen!,
        bucket: bucket,
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await downloadReels();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          width: size.width,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        currentScreen = reelPage();
                        currentTab = 0;
                        setState(() {});
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard,
                            color: currentTab == 0 ? Colors.blue : Colors.grey,
                          ),
                          // Text('Dashboard',
                          //     style: TextStyle(
                          //         color: currentTab == 0
                          //             ? Colors.blue
                          //             : Colors.grey))
                        ],
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        currentScreen = YoutubeDownloader();
                        currentTab = 1;
                        setState(() {});
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            color: currentTab == 1 ? Colors.blue : Colors.grey,
                          ),
                          // Text('Dashboard',
                          //     style: TextStyle(
                          //         color: currentTab == 1
                          //             ? Colors.blue
                          //             : Colors.grey))
                        ],
                      ),
                    ),
                    Container()
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        currentScreen = Center(
                          child: Text('Index 2'),
                        );
                        currentTab = 2;
                        setState(() {});
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: currentTab == 2 ? Colors.blue : Colors.grey,
                          ),
                          // Text('Share',
                          //     style: TextStyle(
                          //         color: currentTab == 2
                          //             ? Colors.blue
                          //             : Colors.grey))
                        ],
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        currentScreen = Center(
                          child: Text('Index 3'),
                        );
                        currentTab = 3;
                        setState(() {});
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: currentTab == 3 ? Colors.blue : Colors.grey,
                          ),
                          // Text('Dashboard',
                          //     style: TextStyle(
                          //         color: currentTab == 3
                          //             ? Colors.blue
                          //             : Colors.grey))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Reel Downloader page
  Widget reelPage() {
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
              await download();
            },
            child: Text("Download"),
          ),
          Text('Progress'),
          Text(progress.toString()),
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

  //Download reel video on button clickl
  download() async {
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
