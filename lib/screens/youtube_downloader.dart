import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_video_info/youtube.dart';

class YoutubeDownloader extends StatefulWidget {
  YoutubeDownloader({Key? key}) : super(key: key);

  @override
  _YoutubeDownloaderState createState() => _YoutubeDownloaderState();
}

class _YoutubeDownloaderState extends State<YoutubeDownloader> {
  final linkController = TextEditingController();

  String youtubeTitle = 'Youtube Video';
  YoutubeDataModel? videoData;

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2465007971338713/9921464426',
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.mediumRectangle,
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

  loadAds() async {
    await myBanner.load();
    setState(() {});
  }

  Future<void> downloadVideo() async {
    await _getStoragePermission();

    EasyLoading.show(status: 'loading...', dismissOnTap: true);
    try {
      videoData = await YoutubeData.getData(linkController.text);
      EasyLoading.dismiss();
      setState(() {});
      print(videoData!.title);

      if (videoData!.title != null) {
        youtubeTitle = videoData!.title!;
      }

      final result = await FlutterYoutubeDownloader.downloadVideo(
          linkController.text, youtubeTitle + '.', 18);

      print(result);
      Fluttertoast.showToast(msg: 'Download Success');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Your link is invalid');
      EasyLoading.dismiss();
    }
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
      if (value != '') {
        try {
          final uri = Uri.parse(value);
          if (uri.host == 'www.youtube.com') {
            setState(() {
              linkController.text = value;
            });
          }
        } catch (e) {
          print('No url on clipboard');
        }
      }
    });
    loadAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(10),
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
            SizedBox(
              height: 10,
            ),
            videoData != null
                ? Container(
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
                          margin: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: videoData!.thumbnailUrl!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                Text(
                                  videoData!.title!,
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                                        Icons.play_circle,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [Text(videoData!.authorName!)],
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
                  )
                : Container(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: AdWidget(ad: myBanner),
                    width: myBanner.size.width.toDouble(),
                    height: myBanner.size.height.toDouble(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
