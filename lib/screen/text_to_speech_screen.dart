import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTS extends StatefulWidget {
  const TTS({Key? key}) : super(key: key);

  @override
  State<TTS> createState() => _TTSState();
}

class _TTSState extends State<TTS> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController controller = TextEditingController();

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 1.0;
  List<String>? languages;
  String langCode = "en-US";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Text To Speech"),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 200,
                    height: 180,
                    child: TextField(
                maxLines: 8, //or null 
                decoration: InputDecoration(
                   border: OutlineInputBorder(),
                   hintText: "Enter your text here",
                )
              ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: _speak,
                    child: const Text("Speak"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: _stop,
                    child: const Text("Stop"),
                  ),
                ],
              ),
              ]),),),);
  }

  void initSetting() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
  }

  void _speak() async {
    initSetting();
    await flutterTts.speak(controller.text);
  }

  void _stop() async {
    await flutterTts.stop();
  }
}