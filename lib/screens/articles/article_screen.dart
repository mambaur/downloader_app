import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    print('Refresing...');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      displacement: 20,
      onRefresh: _refresh,
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: 10,
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return ArticleItem();
          }),
    );
  }
}

class ArticleItem extends StatelessWidget {
  const ArticleItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            width: size.width * 0.2,
            height: size.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                'https://akcdn.detik.net.id/visual/2021/07/26/presiden-lanjutkan-ppkm-level-4_169.jpeg?w=650',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bauroziq',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                    Text(
                      '2021-09-15',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                    'Jokowi soal Nasib 57 Pegawai KPK: Jangan Apa-apa ke Presiden',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Detik.com',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
