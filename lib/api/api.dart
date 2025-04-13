import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://46e8-64-92-84-106.ngrok-free.app";

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

  Future<Map<String, dynamic>> getUser(String uuid) async {
    final url = Uri.parse('$baseUrl/user/$uuid');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Error fetching user: $e');
    }
  }

  Future<List<Map<String, String>>> getDiaryDates(String uuid) async {
    final url = Uri.parse('$baseUrl/diary/dates?uuid=$uuid');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        assert(() {
          print("Diary dates: $responseData");
          return true;
        }());

        return responseData
            .map<Map<String, String>>((entry) => {
                  'date': entry['date'].toString(),
                  'summary': entry['summary'].toString(),
                  'emotion': entry['emotion'].toString(),
                })
            .toList();
      } else {
        throw Exception(
          'Failed to fetch diary dates (status ${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Error fetching diary dates: $e');
    }
  }

  Future<Map<String, dynamic>> generateDiary(String uuid) async {
    final url = Uri.parse('$baseUrl/diary/generate?uuid=$uuid');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uuid': uuid}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'message': responseData['message'],
          'date': responseData['date'],
          'summary': responseData['summary'],
          'emotion': responseData['emotion'],
        };
      } else {
        throw Exception(
          'Failed to generate diary (status ${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Error generating diary: $e');
    }
  }
}
