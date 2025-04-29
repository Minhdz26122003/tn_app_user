import 'dart:convert';
import 'package:http/http.dart' as http;

class Translator {
  /// Hàm dịch dùng MyMemory API
  Future<String> translateWithMyMemory({
    required String text,
    String from = 'auto',
    String to = 'en',
  }) async {
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse('https://api.mymemory.translated.net/get'
        '?q=$encoded&langpair=$from|$to');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['responseData']['translatedText'] as String;
    } else {
      // Xử lý lỗi: trả về nguyên văn
      return text;
    }
  }
}
