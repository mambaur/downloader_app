import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.separated(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 100),
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              contentPadding: EdgeInsets.all(0),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              leading: Icon(Icons.settings),
              title: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Lorem Ipsum Dolor Sit Amet',
                    style: TextStyle(fontSize: 14),
                  )),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 0.4,
            );
          },
          itemCount: 4),
    );
  }
}
