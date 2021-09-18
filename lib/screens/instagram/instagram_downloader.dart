import 'package:downloader/screens/instagram/post_downloader.dart';
import 'package:downloader/screens/instagram/reels_downloader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InstagramDownloader extends StatefulWidget {
  const InstagramDownloader({Key? key}) : super(key: key);

  @override
  _InstagramDownloaderState createState() => _InstagramDownloaderState();
}

class _InstagramDownloaderState extends State<InstagramDownloader>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: TabBar(
      //     controller: _tabController,
      //     tabs: <Widget>[
      //       Tab(
      //         icon: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Icon(FontAwesomeIcons.instagram),
      //             SizedBox(
      //               width: 5,
      //             ),
      //             Text('Reels')
      //           ],
      //         ),
      //       ),
      //       Tab(
      //         icon: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Icon(FontAwesomeIcons.clone),
      //             SizedBox(
      //               width: 5,
      //             ),
      //             Text('Post')
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      //   elevation: 0,
      // ),
      body: PostDownloader(),
      // body: TabBarView(
      //   controller: _tabController,
      //   children: <Widget>[
      //     ReelsDownloader(),
      //     PostDownloader(),
      //   ],
      // ),
    );
  }
}
