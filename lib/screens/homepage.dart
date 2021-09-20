import 'package:downloader/screens/dashboard/dashboard_screen.dart';
import 'package:downloader/screens/howto/howto_screen.dart';
import 'package:downloader/screens/about/about_screen.dart';
import 'package:downloader/screens/instagram/instagram_downloader.dart';
import 'package:downloader/screens/youtube_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:coachmaker/coachmaker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageStorageBucket bucket = PageStorageBucket();
  Widget? currentScreen;
  int currentTab = 0;
  String titleBar = 'Instube Downloader';
  Widget iconTitle = Image.asset(
    'assets/icon-white.png',
    width: 30,
  );

  final List<Widget> screens = [
    DashboardScreen(
      onGetStart: () {},
    ),
    InstagramDownloader(),
    YoutubeDownloader(),
    HowToScreen(),
    AboutScreen(),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconTitle,
            SizedBox(
              width: 5,
            ),
            Text(titleBar),
          ],
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: PageStorage(
        child: currentScreen!,
        bucket: bucket,
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            currentTab != 0 ? Theme.of(context).primaryColor : Colors.white,
        foregroundColor:
            currentTab != 0 ? Colors.white : Theme.of(context).primaryColor,
        // child: Icon(Icons.add),
        child: currentTab == 0
            ? Image.asset(
                'assets/icon.png',
                width: 30,
              )
            : Image.asset(
                'assets/icon-white.png',
                width: 30,
              ),
        onPressed: () {
          setState(() {
            currentScreen = screens[0];
            currentTab = 0;
            titleBar = 'Instube Downloader';
            iconTitle = Image.asset(
              'assets/icon-white.png',
              width: 30,
            );
          });
        },
      ),
      extendBody: true,
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
                      child: CoachPoint(
                        initial: '1',
                        child: MenuIcon(
                            title: 'Insta',
                            icon: FontAwesomeIcons.instagram,
                            color: currentTab == 1 ? Colors.blue : Colors.grey,
                            onTap: () {
                              setState(() {
                                currentScreen = screens[1];
                                currentTab = 1;
                                titleBar = 'Instagram Downloader';
                                iconTitle = Icon(
                                  FontAwesomeIcons.instagram,
                                  size: 30,
                                );
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: CoachPoint(
                        initial: '2',
                        child: MenuIcon(
                            title: 'Youtube',
                            icon: Icons.play_circle_outline,
                            color: currentTab == 2 ? Colors.blue : Colors.grey,
                            onTap: () {
                              setState(() {
                                currentScreen = screens[2];
                                currentTab = 2;
                                titleBar = 'Youtube Downloader';
                                iconTitle = Icon(
                                  Icons.play_circle_outline,
                                  size: 30,
                                );
                              });
                            }),
                      ),
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
                      child: CoachPoint(
                        initial: '3',
                        child: MenuIcon(
                            title: 'How To',
                            icon: FontAwesomeIcons.medapps,
                            color: currentTab == 3 ? Colors.blue : Colors.grey,
                            onTap: () {
                              setState(() {
                                currentScreen = screens[3];
                                currentTab = 3;
                                titleBar = 'How To';
                                iconTitle = Icon(
                                  FontAwesomeIcons.medapps,
                                  size: 30,
                                );
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: CoachPoint(
                        initial: '4',
                        child: MenuIcon(
                            title: 'About',
                            icon: FontAwesomeIcons.questionCircle,
                            color: currentTab == 4 ? Colors.blue : Colors.grey,
                            onTap: () {
                              setState(() {
                                currentScreen = screens[4];
                                currentTab = 4;
                                titleBar = 'About Instube';
                                iconTitle = Icon(
                                  FontAwesomeIcons.questionCircle,
                                  size: 30,
                                );
                              });
                            }),
                      ),
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
