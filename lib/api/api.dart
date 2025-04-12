import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.172.24.125:8000";

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

  Future<String> postMessage(String message, String userUuid) async {
    final url = Uri.parse('$baseUrl/chat');
    print("Sending request to: $url");
    print("With data: message='$message', uuid='$userUuid'");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message, 'uuid': userUuid}),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 500 || response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(decoded);
        print("Parsed response: $responseData");
        return responseData['response'];
      } else {
        throw Exception('Failed to post message: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Error posting message: $e');
    }
  }
}
