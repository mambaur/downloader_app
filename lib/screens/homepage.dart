import 'package:downloader/screens/articles/article_screen.dart';
import 'package:downloader/screens/helps/help_screen.dart';
import 'package:downloader/screens/instagram/instagram_downloader.dart';
import 'package:downloader/screens/youtube_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageStorageBucket bucket = PageStorageBucket();
  Widget? currentScreen;
  int currentTab = 0;
  String titleBar = 'Instagram Downloader';

  final List<Widget> screens = [
    InstagramDownloader(),
    YoutubeDownloader(),
    ArticleScreen(),
    HelpScreen(),
  ];

  @override
  void initState() {
    currentScreen = screens[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(titleBar),
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
        onPressed: () {},
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
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MenuIcon(
                          title: 'Insta',
                          icon: FontAwesomeIcons.instagram,
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                          onTap: () {
                            setState(() {
                              currentScreen = screens[0];
                              currentTab = 0;
                              titleBar = 'Instagram Downloader';
                            });
                          }),
                    ),
                    Expanded(
                      child: MenuIcon(
                          title: 'Youtube',
                          icon: Icons.play_circle_outline,
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                          onTap: () {
                            setState(() {
                              currentScreen = screens[1];
                              currentTab = 1;
                              titleBar = 'Youtube Downloader';
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 2, child: Container()),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MenuIcon(
                          title: 'News',
                          icon: FontAwesomeIcons.newspaper,
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                          onTap: () {
                            setState(() {
                              currentScreen = screens[2];
                              currentTab = 2;
                              titleBar = 'News';
                            });
                          }),
                    ),
                    Expanded(
                      child: MenuIcon(
                          title: 'Help',
                          icon: FontAwesomeIcons.questionCircle,
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                          onTap: () {
                            setState(() {
                              currentScreen = screens[3];
                              currentTab = 3;
                              titleBar = 'Help';
                            });
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuIcon extends StatelessWidget {
  final Function()? onTap;
  final Color? color;
  final IconData? icon;
  final String? title;
  const MenuIcon({Key? key, this.onTap, this.color, this.icon, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      // constraints: BoxConstraints(),
      onPressed: onTap ?? () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.home,
            color: color ?? Colors.grey,
            // color: currentTab == 3 ? Colors.blue : Colors.grey,
          ),
          SizedBox(
            height: 3,
          ),
          Text(title ?? 'Home',
              style: TextStyle(
                  color: color ?? Colors.grey,
                  fontSize: MediaQuery.of(context).size.width * 0.035))
        ],
      ),
    );
  }
}
