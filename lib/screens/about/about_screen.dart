import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_review/in_app_review.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String version = '...';

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }

  final InAppReview inAppReview = InAppReview.instance;

  appReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      Fluttertoast.showToast(msg: 'Rate no available');
    }
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                onTap: () => appReview,
                leading: Icon(FontAwesomeIcons.star),
                title: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Rate Instube Downloader',
                      style: TextStyle(fontSize: 14),
                    )),
              ),
              ListTile(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    // title: const Text('Author'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.white,
                            child: Image.asset(
                              'assets/author.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text('Bauroziq - CRG Studio'),
                          GestureDetector(
                              onTap: () {
                                _launchURL('https://bauroziq.com');
                              },
                              child: Text('Bauroziq.com',
                                  style: TextStyle(color: Colors.grey))),
                          SizedBox(
                            height: 15,
                          ),
                          Text('Support at'),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () =>
                                    _launchURL('https://saweria.co/bauroziq'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Theme.of(context).primaryColor),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/saweria.png',
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Saweria',
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => _launchURL(
                                    'https://www.buymeacoffee.com/bauroziq'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Theme.of(context).primaryColor),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/buymeacoffee.png',
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Buy me a Coffee',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      // TextButton(
                      //   onPressed: () => Navigator.pop(context, 'Cancel'),
                      //   child: const Text('Cancel'),
                      // ),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('Go Back'),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: Icon(FontAwesomeIcons.userCircle),
                title: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Author',
                      style: TextStyle(fontSize: 14),
                    )),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(FontAwesomeIcons.exclamationCircle),
                title: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Version $version',
                      style: TextStyle(fontSize: 14),
                    )),
              )
            ],
          ),
        ));
  }
}
