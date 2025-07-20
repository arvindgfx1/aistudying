import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class ElevenLabsTTSService {
  static const String _apiKey = 'sk_89f700a710f9d3d6cfe19db38f9185aa6c72c774d93e1980';
  static const String _defaultVoiceId = 'EXAVITQu4vr4xnSDxMaL'; // Default voice

  static Future<void> speak(String text, {String? voiceId}) async {
    final usedVoiceId = voiceId ?? _defaultVoiceId;
    final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$usedVoiceId');
    final headers = {
      'xi-api-key': _apiKey,
      'Content-Type': 'application/json',
      'accept': 'audio/mpeg',
    };
    final body = jsonEncode({
      'text': text,
      'model_id': 'eleven_monolingual_v1',
      'voice_settings': {
        'stability': 0.5,
        'similarity_boost': 0.5,
      }
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final audioPlayer = AudioPlayer();
      await audioPlayer.play(BytesSource(response.bodyBytes));
    } else {
      throw Exception('Failed to get TTS audio: \n${response.statusCode} ${response.reasonPhrase}');
    }
  }
} 