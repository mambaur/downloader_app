import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Content {
  static data() {
    return <Map<String, dynamic>>[
      {
        "type": "Instagram",
        "title": "How to Download Content from Instagram",
        "icon": Icon(
          FontAwesomeIcons.instagram,
          size: 35,
          color: Colors.blue.shade600,
        ),
        'route': '/instagram-tutorial'
      },
      {
        "type": "Youtube",
        "title": "How to Download Video from Youtube",
        "icon": Icon(
          Icons.play_circle_outline,
          size: 35,
          color: Colors.blue.shade600,
        ),
        'route': '/youtube-tutorial'
      }
    ];
  }
}
