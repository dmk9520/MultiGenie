import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:flutter_acrcloud_demo/models/music_model.dart';
import 'package:flutter_acrcloud_demo/widgets/ripple_animation.dart';
import 'package:flutter_acrcloud_demo/store_handler/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecognizeScreen extends StatefulWidget {
  const RecognizeScreen({Key? key}) : super(key: key);

  @override
  State<RecognizeScreen> createState() => _RecognizeScreenState();
}

class _RecognizeScreenState extends State<RecognizeScreen> {
  ACRCloudResponseMusicItem? music;
  bool isListening = false;
  DatabaseHelper helper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isListening) const Expanded(child: RipplesAnimation()),
          if (!isListening)
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(56),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    setState(() {
                      isListening = true;
                      music = null;
                    });

                    final session = ACRCloud.startSession();

                    await Future.delayed(const Duration(seconds: 5));
                    final result = await session.result;
                    print('------result-status----${result!.status.msg}');
                    print('------result-metadata----${result.metadata}');
                    setState(() {
                      isListening = false;
                    });

                    if (result == null) {
                      // Cancelled.
                      return;
                    } else if (result.metadata == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('No result.'),
                      ));
                      return;
                    }

                    setState(() {
                      music = result.metadata!.music.first;
                    });
                    await helper.insertMusicData(MusicData(
                        title: music!.title,
                        artist: music!.artists.first.name,
                        album: music!.album.name));
                  },
                  child: Column(
                    children: const [
                      Text("Tap to Listen")
                      
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          if (music != null) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.redAccent,
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Track: ${music!.title}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Album: ${music!.album.name}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  Text('Artist: ${music!.artists.first.name}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  addItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }
}
