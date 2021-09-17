import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.all(10),
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Try download your favourite video on Youtube or instagram Free!',
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
                onPressed: () {},
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
    );
  }
}
