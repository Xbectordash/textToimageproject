import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiHandler {
  static const String _flaskUrl = "http://10.0.2.2:5000/generate-image"; // Replace with your server URL

  static Future<Uint8List> generateImage(String description) async {
    try {
      final response = await http.post(
        Uri.parse(_flaskUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"prompt": description}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey("image")) {
          return base64Decode(responseData["image"]);
        } else {
          throw Exception('Server response missing image data');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to generate image: $error');
    }
  }
}