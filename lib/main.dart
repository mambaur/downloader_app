import 'package:downloader/screens/homepage.dart';
import 'package:downloader/screens/howto/instagram-tutorial.dart';
import 'package:downloader/screens/howto/youtube-tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instant Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/instagram-tutorial': (context) => InstagramTutorial(),
        '/youtube-tutorial': (context) => YoutubeTutorial(),
      },
    );
  }
}
