import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordSpoken = "";
  double _confidencelevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidencelevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordSpoken = "${result.recognizedwords}";
      _confidencelevel = result.Confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Speech Demo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "listening..."
                    : _speechEnabled
                        ? "Tap th microphone to start listening..."
                        : "Speech not available",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  _wordSpoken,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            if (_speechToText.isNotListening && _confidencelevel > 0)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ),
                child: Text(
                  "Confidence: ${(_confidencelevel * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
