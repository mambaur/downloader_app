import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                onTap: () {},
                leading: Icon(FontAwesomeIcons.star),
                title: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Rate Instant Downloader',
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
                            child: CircleAvatar(
                              child: ClipRect(
                                child: Image.asset(
                                  'assets/author.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Bauroziq - CRG Studio'),
                          Text('Support at :'),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () =>
                                    _launchURL('https://saweria.co/bauroziq'),
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
                                      style: TextStyle(color: Colors.white),
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
                leading: Icon(FontAwesomeIcons.infoCircle),
                title: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 14),
                    )),
              )
            ],
          ),
        ));
  }
}
