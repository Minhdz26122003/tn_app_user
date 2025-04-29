// class ServiceController extends GetxController {
//   var services = <Service>[].obs;
//   final Translator _translator = Translator();

//   /// Gọi API và dịch tên service về locale hiện tại của GetX
//   Future<void> fetchAndTranslateServices() async {
//     final langCode = Get.locale?.languageCode ?? 'en';

//     // 1. Gọi API
//     final uri = Uri.parse('https://api.yourdomain.com/get_services.php');
//     final body = {
//       'time': DateTime.now().millisecondsSinceEpoch.toString(),
//       'keyCert': YOUR_KEY_CERT,
//       // Bạn vẫn giữ 'lang' nếu backend hỗ trợ 1 ngôn ngữ mặc định
//     };
//     final res = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(body),
//     );
//     if (res.statusCode != 200) return;

//     final data = jsonDecode(res.body);
//     final items = (data['items'] as List)
//         .map((e) => Service.fromJson(e))
//         .toList();

//     // 2. Dịch serviceName từng mục
//     for (var svc in items) {
//       svc.serviceName = await _translator.translate(
//         svc.serviceName,
//         from: 'auto',
//         to: langCode,
//       );
//     }

//     // 3. Cập nhật observable để UI rebuild
//     services.value = items;
//   }
// }