import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String _apiKey = 'AIzaSyAmVekOoCfdyUdiN-jYy7FP6_KDmsWetxg'; // Replace with your Gemini API key
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> getAIResponse({required String userMessage}) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-goog-api-key': _apiKey,
    };

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': userMessage}
          ]
        }
      ]
    });

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Gemini returns candidates[0].content.parts[0].text
      try {
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response from Gemini.';
      } catch (_) {
        return 'No valid response from Gemini.';
      }
    } else {
      String errorMsg = 'Failed to get AI response: \\n${response.statusCode} ${response.reasonPhrase}';
      try {
        final data = jsonDecode(response.body);
        if (data['error'] != null && data['error']['message'] != null) {
          errorMsg += '\n${data['error']['message']}';
        }
      } catch (_) {}
      return errorMsg;
    }
  }
} 