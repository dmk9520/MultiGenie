import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TTS extends StatefulWidget {
  const TTS({Key? key}) : super(key: key);

  @override
  State<TTS> createState() => _TTSState();
}

class _TTSState extends State<TTS> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController controller = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
        // TODO: Handle this case.
        break;
    }
  }
  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  @override
  void initState() {
    super.initState();
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "en_En",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      _textController.text = _lastWords;
    });
  }

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
          margin: const EdgeInsets.all(10),
          child: Center(
            child: Column(
                children: [
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          minLines: 6,
                          maxLines: 10,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      FloatingActionButton.small(
                        onPressed:
                        // If not yet listening for speech start, otherwise stop
                        _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                        tooltip: 'Listen',
                        backgroundColor: Colors.blueGrey,
                        child: Icon(_speechToText
                            .isNotListening
                            ? Icons.mic_off
                            : Icons.mic),
                      )
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