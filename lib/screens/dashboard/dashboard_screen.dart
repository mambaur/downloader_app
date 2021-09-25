// import 'package:coachmaker/coachmaker.dart';
import 'dart:isolate';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instagram_public_api/instagram_public_api.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final Function()? onGetStart;
  const DashboardScreen({Key? key, this.onGetStart}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ReceivePort _port = ReceivePort();
  final postController = TextEditingController();
  List<InstaPost> posts = [];
  String version = '...';

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2465007971338713/9921464426',
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final AdSize adSize = AdSize(width: 320, height: 250);

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

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

  loadAds() async {
    await myBanner.load();
    setState(() {});
  }

  @override
  void initState() {
    getVersion();
    loadAds();

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
    return Scaffold(
      // alignment: Alignment.center,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.all(10),
        // margin: EdgeInsets.only(top: size.height * 0.1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: AdWidget(ad: myBanner),
                      width: myBanner.size.width.toDouble(),
                      height: myBanner.size.height.toDouble(),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: size.height * 0.02,
              // ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  '${greeting()}!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Let's try fast download your favourite content on Instagram for free now!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Image.asset(
                'assets/flat-people.png',
                width: size.width * 0.7,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    // ElevatedButton(
                    //     onPressed: () {
                    //       CoachMaker(context,
                    //               initialList: [
                    //                 CoachModel(
                    //                     initial: '1',
                    //                     title: 'Instagram Downloader',
                    //                     maxWidth: 400,
                    //                     subtitle: [
                    //                       'Download your favourite content in Instagram, such as posts, reels, stories, and more.',
                    //                       // 'Next Description',
                    //                     ],
                    //                     header: Icon(
                    //                       FontAwesomeIcons.instagram,
                    //                       size: 50,
                    //                       color: Theme.of(context).primaryColor,
                    //                     )),
                    //                 CoachModel(
                    //                     initial: '2',
                    //                     title: 'Youtube Downloader',
                    //                     maxWidth: 400,
                    //                     subtitle: [
                    //                       'Download your favourite youtube video for free now.',
                    //                       // 'Next Description',
                    //                     ],
                    //                     header: Icon(
                    //                       Icons.play_circle_outline,
                    //                       size: 50,
                    //                       color: Theme.of(context).primaryColor,
                    //                     )),
                    //                 CoachModel(
                    //                     initial: '3',
                    //                     title: 'How To',
                    //                     maxWidth: 400,
                    //                     subtitle: [
                    //                       'Tutorial how to use this downloader.',
                    //                       // 'Next Description',
                    //                     ],
                    //                     header: Icon(
                    //                       FontAwesomeIcons.medapps,
                    //                       size: 50,
                    //                       color: Theme.of(context).primaryColor,
                    //                     )),
                    //                 CoachModel(
                    //                     initial: '4',
                    //                     title: 'About',
                    //                     maxWidth: 400,
                    //                     subtitle: [
                    //                       'What you should know about this app.',
                    //                       // 'Next Description',
                    //                     ],
                    //                     header: Icon(
                    //                       FontAwesomeIcons.questionCircle,
                    //                       size: 50,
                    //                       color: Theme.of(context).primaryColor,
                    //                     )),
                    //               ],
                    //               nextStep: CoachMakerControl.next,
                    //               buttonOptions: CoachButtonOptions(
                    //                   buttonTitle: 'Next',
                    //                   buttonStyle: ButtonStyle(
                    //                       backgroundColor:
                    //                           MaterialStateProperty.all(
                    //                               Theme.of(context).primaryColor),
                    //                       elevation:
                    //                           MaterialStateProperty.all(0))))
                    //           .show();
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //         primary: Colors.white,
                    //         onPrimary: Theme.of(context).primaryColor),
                    //     child: Text(
                    //       'Get Started',
                    //       style: TextStyle(color: Theme.of(context).primaryColor),
                    //     )),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Theme.of(context).primaryColor),
                        child: Text(
                          'Paste Link',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
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
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Theme.of(context).primaryColor),
                        child: Text(
                          'Download',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () async {
                          await _getInstaPosts();
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Version $version",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
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
