import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  // Khởi tạo một thể hiện singleton. Đây là điểm duy nhất mà _internal() được gọi.
  static final GeminiService _instance = GeminiService._internal();

  // Factory constructor để luôn trả về thể hiện singleton.
  factory GeminiService() {
    return _instance;
  }

  // Constructor riêng tư, chỉ có thể được gọi từ bên trong class.
  GeminiService._internal() {
    // Lấy API Key từ biến môi trường
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_FALLBACK_API_KEY';
    if (_apiKey == 'YOUR_FALLBACK_API_KEY' || _apiKey.isEmpty) {
      print(
          'Lỗi: GEMINI_API_KEY không được tìm thấy trong file .env hoặc rỗng.');
      // throw Exception('API Key for Gemini not found!');
    }
    _model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: _apiKey);

    // Khởi tạo _chatSession chỉ một lần khi GeminiService được tạo lần đầu.
    _chatSession = _model.startChat();
  }

  late final GenerativeModel _model;
  late final String _apiKey;
  late ChatSession _chatSession;

  // Hàm để gửi tin nhắn đến Gemini và nhận phản hồi (ít dùng cho chat liên tục)
  Future<String> getGeminiResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Không có phản hồi từ AI.';
    } catch (e) {
      print('Lỗi khi gọi Gemini API: $e');
      return 'Đã xảy ra lỗi khi xử lý yêu cầu của bạn. Vui lòng thử lại sau.';
    }
  }

  // Hàm xử lý các cuộc hội thoại (chat) liên tục
  Future<String> sendChatMessage(String userMessage) async {
    try {
      // Gửi tin nhắn của người dùng vào phiên chat hiện tại
      final response =
          await _chatSession.sendMessage(Content.text(userMessage));
      return response.text ?? 'Không có phản hồi từ AI.';
    } catch (e) {
      print('Lỗi khi chat với Gemini: $e');
      return 'Đã xảy ra lỗi khi xử lý tin nhắn của bạn. Vui lòng thử lại sau.';
    }
  }

  // Hàm để lấy lịch sử chat hiện tại
  List<Content> get chatHistory => _chatSession.history.toList();

  // Hàm mới để đặt lại phiên chat nếu cần (ví dụ: khi chuyển chế độ)
  void startNewChatSession() {
    _chatSession = _model.startChat();
  }
}
