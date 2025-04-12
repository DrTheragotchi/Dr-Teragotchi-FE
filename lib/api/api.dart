import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.175.118.64:8000";

  Future<Map<String, dynamic>> postOnboarding(
      String uuid, String nickname) async {
    final url = Uri.parse('$baseUrl/onboarding');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uuid': uuid, 'nickname': nickname}),
    );

    if (response.statusCode == 500 || response.statusCode == 200) {
      print("worked");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post onboarding: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> postMessage(
      String message, String userUuid, String emotion) async {
    final url = Uri.parse('$baseUrl/chat');
    print("Sending message: $message");
    print("User UUID: $userUuid");
    print("Emotion: $emotion");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'uuid': userUuid,
          'emotion': emotion,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 500) {
        final decoded = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(decoded);

        return {
          'response': responseData['response'] ?? '',
          'emotion': responseData['emotion'], // may be null
          'animal': responseData['animal'], // may be null
          'points': responseData['points'],
          'isFifth': responseData['isFifth'] ?? false,
        };
      } else {
        throw Exception('Failed to post message: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Error posting message: $e');
    }
  }
}
