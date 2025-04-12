import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.0.0.2:8000";

  Future<Map<String, dynamic>> postOnboarding(
      String uuid, String nickname) async {
    final url = Uri.parse('$baseUrl/onboarding');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uuid': uuid, 'nickname': nickname}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post onboarding: ${response.statusCode}');
    }
  }
}
