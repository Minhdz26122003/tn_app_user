import 'dart:convert';
import 'package:http/http.dart' as http;

class Translator {
  static const String _baseUrl = "https://libretranslate.com/translate";

  Future<String> translate(String text,
      {String from = "auto", String to = "en"}) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {"q": text, "source": from, "target": to, "format": "text"}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["translatedText"];
      } else {
        print("Lỗi khi dịch: ${response.body}");
        return text; // Trả về nguyên văn nếu lỗi
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
      return text;
    }
  }
}
