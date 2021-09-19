import 'package:coachmaker/coachmaker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final Function()? onGetStart;
  const DashboardScreen({Key? key, this.onGetStart}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // alignment: Alignment.center,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: size.height * 0.1),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                padding: EdgeInsets.all(5),
                child: Text(
                  'Try download your favourite content on Youtube or Instagram Free!',
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
              ElevatedButton(
                  onPressed: () {
                    CoachMaker(context,
                            initialList: [
                              CoachModel(
                                  initial: '1',
                                  title: 'Instagram Downloader',
                                  maxWidth: 400,
                                  subtitle: [
                                    'Download your favourite content in Instagram, such as posts, reels, stories, and more.',
                                    // 'Next Description',
                                  ],
                                  header: Icon(
                                    FontAwesomeIcons.instagram,
                                    size: 50,
                                  )),
                              CoachModel(
                                  initial: '2',
                                  title: 'Youtube Downloader',
                                  maxWidth: 400,
                                  subtitle: [
                                    'Download your favourite youtube video for free now.',
                                    // 'Next Description',
                                  ],
                                  header: Icon(
                                    Icons.play_circle_outline,
                                    size: 50,
                                  )),
                              CoachModel(
                                  initial: '3',
                                  title: 'How To',
                                  maxWidth: 400,
                                  subtitle: [
                                    'Tutorial how to use this downloader.',
                                    // 'Next Description',
                                  ],
                                  header: Icon(
                                    FontAwesomeIcons.newspaper,
                                    size: 50,
                                  )),
                              CoachModel(
                                  initial: '4',
                                  title: 'About',
                                  maxWidth: 400,
                                  subtitle: [
                                    'What you should know about this app.',
                                    // 'Next Description',
                                  ],
                                  header: Icon(
                                    FontAwesomeIcons.questionCircle,
                                    size: 50,
                                  )),
                            ],
                            nextStep: CoachMakerControl.next,
                            buttonOptions: CoachButtonOptions(
                                buttonTitle: 'Next',
                                buttonStyle: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    elevation: MaterialStateProperty.all(0))))
                        .show();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Theme.of(context).primaryColor),
                  child: Text(
                    'Get Started',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
