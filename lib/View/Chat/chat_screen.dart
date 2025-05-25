import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

enum ChatMode { faq, feedback } // Định nghĩa các chế độ

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  // Khởi tạo GeminiService
  final GeminiService _geminiService = GeminiService();
  final List<Map<String, String>> _messages = []; // Danh sách lưu trữ tin nhắn
  bool _isLoading = false;
  ChatMode _currentMode = ChatMode.faq;

  @override
  void initState() {
    super.initState();
    // Gửi một tin nhắn khởi tạo (system prompt) khi bắt đầu để định hướng AI
    _initializeChatMode();
  }

  void _initializeChatMode() {
    String initialPrompt;
    if (_currentMode == ChatMode.faq) {
      initialPrompt = """
      Bạn là một trợ lý ảo cho ứng dụng đặt lịch hẹn. Nhiệm vụ của bạn là trả lời các câu hỏi thường gặp
      về ứng dụng đặt lịch sửa chữa và bảo dưỡng ô tô, dịch vụ, và chính sách.
      Nếu người dùng hỏi về các chủ đề không liên quan, hãy lịch sự từ chối và hướng dẫn họ về các câu hỏi
      liên quan đến đặt lịch hẹn hoặc dịch vụ của chúng tôi.
      Dưới đây là một số ví dụ về FAQ và câu trả lời bạn có thể dựa vào:
      - "Làm thế nào để đặt lịch hẹn?": Bạn có thể đặt lịch hẹn bằng cách chọn dịch vụ, chọn thời gian, và xác nhận trên ứng dụng.
      - "Tôi có thể hủy lịch hẹn không?": Có, bạn có thể hủy lịch hẹn trong phần "Lịch hẹn của tôi" trước 24 giờ.
      - "Các dịch vụ của bạn là gì?": Chúng tôi cung cấp các dịch vụ như Dịch vụ bảo dưỡng định kỳ, Dịch vụ vệ sinh kim phun và buồng đốt ô tô, Dịch vụ bảo dưỡng hệ thống phanh,... . Vui lòng xem danh sách chi tiết trong ứng dụng.
      - "Gara mở cửa lúc mấy giờ?": Gara của chúng tôi mở cửa từ 8 giờ sáng đến 5 giờ chiều, từ thứ Hai đến Chủ nhật.
      - "Tôi có thể thanh toán bằng thẻ tín dụng không?": Có, chúng tôi chấp nhận thanh toán bằng thẻ tín dụng và tiền mặt.
      - "Tôi có thể đặt lịch hẹn cho người khác không?": Có, bạn có thể đặt lịch hẹn cho người khác bằng cách nhập thông tin của họ trong quá trình đặt lịch.
      - "Tôi có thể đặt lịch hẹn qua điện thoại không?": Hiện tại, chúng tôi chỉ hỗ trợ đặt lịch hẹn qua ứng dụng. Vui lòng sử dụng ứng dụng để đặt lịch.
      - "Tôi có thể đặt lịch hẹn vào cuối tuần không?": Có, bạn có thể đặt lịch hẹn vào cuối tuần tùy thuộc vào tình trạng sẵn có của dịch vụ.
      - "Tôi có thể thay đổi lịch hẹn đã đặt không?": Có, bạn có thể thay đổi lịch hẹn đã đặt trong phần "Lịch hẹn của tôi" trước 24 giờ.
      - "Tôi có thể đặt lịch hẹn cho dịch vụ nào?": Bạn có thể đặt lịch hẹn cho các dịch vụ như Dịch vụ bảo dưỡng định kỳ, Dịch vụ vệ sinh kim phun và buồng đốt ô tô, Dịch vụ bảo dưỡng hệ thống phanh,... . Vui lòng xem danh sách chi tiết trong ứng dụng.
      - "Tôi có thể đặt lịch hẹn cho ngày mai không?": Có, bạn có thể đặt lịch hẹn cho ngày mai nếu còn thời gian trống.
      - "Địa chỉ của gara là ở đâu?": Địa chỉ của gara ở SH1KT02, Vinhomes OCP2, Văn Giang, Hưng Yên, Việt Nam.
      Bạn đã sẵn sàng nhận câu hỏi FAQ.
      """;
      _addMessage('model',
          'Chào bạn! Tôi có thể giúp gì cho bạn về các câu hỏi thường gặp?');
    } else {
      // ChatMode.feedback
      initialPrompt = """
      Bạn là một trợ lý ảo chuyên thu thập phản hồi và đánh giá sau dịch vụ cho ứng dụng đặt lịch hẹn.
      Hãy hỏi người dùng về trải nghiệm của họ, mức độ hài lòng, và bất kỳ góp ý nào họ có.
      Nếu người dùng đưa ra đánh giá sao (ví dụ: "5 sao", "tuyệt vời"), hãy cảm ơn họ.
      Nếu người dùng đưa ra góp ý hoặc vấn đề, hãy cảm ơn họ đã phản hồi và nói rằng chúng tôi sẽ chuyển
      thông tin này đến bộ phận liên quan để cải thiện.

      Ví dụ về tương tác:
      - AI: "Chào bạn! Bạn có thể chia sẻ phản hồi về lịch hẹn gần đây của mình không?"
      - Người dùng: "Dịch vụ rất tốt, tôi rất hài lòng!"
      - AI: "Cảm ơn bạn rất nhiều vì phản hồi tích cực! Rất vui được phục vụ bạn."

      - Người dùng: "Tôi nghĩ thời gian chờ đợi hơi lâu."
      - AI: "Cảm ơn bạn đã chia sẻ phản hồi. Chúng tôi sẽ ghi nhận và cố gắng cải thiện để mang lại trải nghiệm tốt hơn trong tương lai."

      Bạn đã sẵn sàng nhận phản hồi.
      """;
      _addMessage('model',
          'Chào bạn! Bạn có thể chia sẻ phản hồi về lịch hẹn gần đây của mình không?');
    }
    // Gửi prompt khởi tạo này đến Gemini để định hướng nó.
    _geminiService.sendChatMessage(initialPrompt);
  }

  void _addMessage(String role, String text) {
    setState(() {
      _messages.add({'role': role, 'text': text});
    });
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _addMessage('user', message); // Thêm tin nhắn của người dùng vào danh sách

    setState(() {
      _isLoading = true;
    });
    _messageController.clear();

    try {
      //  Gửi tin nhắn của người dùng đến Gemini sẽ sử dụng lịch sử chat bên trong ChatSession để duy trì ngữ cảnh.
      final geminiResponse = await _geminiService.sendChatMessage(message);
      _addMessage('model', geminiResponse); // Thêm phản hồi của AI
    } catch (e) {
      _addMessage('model', 'Đã xảy ra lỗi: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Hỗ trợ & Phản hồi',
            style: const TextStyle(color: ColorHex.white, fontSize: 17)),
        backgroundColor: ColorHex.total_color,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: ColorHex.white),
        ),
        actions: [
          PopupMenuButton<ChatMode>(
            onSelected: (mode) {
              setState(() {
                _currentMode = mode;
                _messages.clear(); // Xóa lịch sử chat
                _initializeChatMode(); // Khởi tạo lại chat session và prompt
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ChatMode>>[
              const PopupMenuItem<ChatMode>(
                value: ChatMode.faq,
                child: Text('Chế độ Hỏi & Đáp (FAQ)',
                    style: TextStyle(color: ColorHex.black, fontSize: 13)),
              ),
              const PopupMenuItem<ChatMode>(
                value: ChatMode.feedback,
                child: Text('Chế độ Phản hồi & Đánh giá',
                    style: TextStyle(color: ColorHex.black, fontSize: 13)),
              ),
            ],
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blue.shade200
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        msg['text']!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _currentMode == ChatMode.faq
                          ? 'Nhập câu hỏi của bạn...'
                          : 'Chia sẻ phản hồi của bạn...',
                      hintStyle: TextStyle(color: ColorHex.black, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
