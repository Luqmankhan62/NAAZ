import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceHandler {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<void> speak(String text) async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.1);
    await _tts.speak(text);
  }

  Future<String?> listen() async {
    bool available = await _speech.initialize();
    if (!available) return null;
    await _speech.listen();
    await Future.delayed(const Duration(seconds: 5));
    await _speech.stop();
    return _speech.lastRecognizedWords;
  }
}
