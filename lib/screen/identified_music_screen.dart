import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:math' as math;

import '../models/music_model.dart';
import '../store_handler/database_helper.dart';

class IdentifiedMusicScreen extends StatefulWidget {
  const IdentifiedMusicScreen({Key? key}) : super(key: key);

  @override
  State<IdentifiedMusicScreen> createState() => _IdentifiedMusicScreenState();
}

class _IdentifiedMusicScreenState extends State<IdentifiedMusicScreen> {
  DatabaseHelper helper = DatabaseHelper();
  List<MusicData> musicData = [];
  bool isLoaded = false;

  //******  LOAD LIST WITH LOCAL STORAGE DATA  ********
  void getMusicData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<MusicData>?> musicDataList = helper.getMusicDataList();
      musicDataList.then((data) {
        print('--------data-----$data');
        if (data!.isNotEmpty) {
          setState(() {
            musicData = data;
            isLoaded = true;
          });
          print('----musicData-=------$musicData');
        }
      });
    });
  }

  @override
  void initState() {
    getMusicData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? musicData.isEmpty
            ? const Center(child: Text('No data available'))
            : ListView.builder(
                itemCount: musicData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      isThreeLine: true,
                      leading: Icon(Icons.multitrack_audio_sharp, size: 30,color: Colors.redAccent,),
                      tileColor: const Color.fromRGBO(230, 230, 230, 100),
                      contentPadding: const EdgeInsets.all(10),
                      title: Text(musicData[index].title!),
                      subtitle: Text(musicData[index].artist! + "\n\nTap to Listen"),

                      onTap: () {
                        String searchQuery =
                            '${musicData[index].title} ${musicData[index].artist} lyrics';
                        launchUrlString(
                            'https://www.youtube.com/results?search_query=$searchQuery');
                      },
                      trailing: IconButton(
                          onPressed: () async {
                            musicData.removeAt(index);
                            await helper.deleteMusicData(musicData[index]);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                })
        : Container();
  }
}
