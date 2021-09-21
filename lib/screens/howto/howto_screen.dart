import 'package:downloader/screens/howto/content.dart';
import 'package:flutter/material.dart';

class HowToScreen extends StatefulWidget {
  const HowToScreen({Key? key}) : super(key: key);

  @override
  _HowToScreenState createState() => _HowToScreenState();
}

class _HowToScreenState extends State<HowToScreen> {
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    print('Refresing...');
  }

  List<Map<String, dynamic>> content = Content.data();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      displacement: 20,
      onRefresh: _refresh,
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: content.length,
          padding: EdgeInsets.only(top: 15, bottom: 100),
          itemBuilder: (context, index) {
            return ArticleItem(content: content[index]);
          }),
    );
  }
}

class ArticleItem extends StatelessWidget {
  final Map<String, dynamic> content;
  const ArticleItem({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: MaterialButton(
        onPressed: () => Navigator.of(context).pushNamed(content['route']),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200),
              width: size.width * 0.15,
              height: size.width * 0.15,
              child: Center(
                child: content['icon'],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(content['type']),
                  SizedBox(
                    height: 3,
                  ),
                  Text(content['title'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
