import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:flutter_acrcloud_demo/screen/text_to_speech_screen.dart';

import 'screen/Recognizing_screen.dart';
import 'screen/identified_music_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int navIndex = 0;

  @override
  void initState() {
    super.initState();
    ACRCloud.setUp(ACRCloudConfig('4c536d94fdf69c8ef86ac48933f616b9'
        , 'duCqITYnuUO02Grh8Gbhi2fL0x27LA81xhb7uSrp'
        , 'identify-ap-southeast-1.acrcloud.com'));
  }

  final List<Widget> _pages = <Widget>[
    RecognizeScreen(),
    IdentifiedMusicScreen(),
    TTS(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[navIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            navigationItem(navIndex, 0, Icons.record_voice_over, 'Recognizing'),
            navigationItem(navIndex, 1, Icons.list_alt, 'List'),
            navigationItem(navIndex, 2, Icons.speaker, 'TTS'),
          ],
          selectedLabelStyle: TextStyle(fontSize: 12, color:  Colors.red, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.grey),
          type: BottomNavigationBarType.fixed,
      
          backgroundColor: Colors.redAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: navIndex,
          onTap: (index) {
            setState(() {
              navIndex=index;
            });
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem navigationItem(
      int selectedIndex,
      int index,
      IconData icon,
      String label,
      ) {
    return BottomNavigationBarItem(
      tooltip: "",
      icon: Icon(icon, size: 20),
      label: label,
    );
  }
}
