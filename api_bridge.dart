import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiBridge {
  static const String apiBaseUrl = "http://localhost:5050";

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse("$apiBaseUrl/chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["reply"] ?? "No reply from Naaz AI.";
      } else {
        return "⚠️ Server error: ${response.statusCode}";
      }
    } catch (e) {
      return "❌ Connection failed: $e";
    }
  }
}
