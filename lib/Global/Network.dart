import 'package:network_info_plus/network_info_plus.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:http/http.dart' as http;

Future<String> getLocalIP() async {
  try {
    String subnet = "192.168.1";
    for (int i = 1; i < 255; i++) {
      String ip = "$subnet.$i";
      String url = "http://$ip/apihm";

      try {
        final response =
            await http.get(Uri.parse(url)).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          return url;
        }
      } catch (e) {
        print("Lỗi khi lấy địa chỉ IP: $e");
      }
    }
  } catch (e) {
    print("Lỗi khi lấy địa chỉ IP: $e");
  }
  return "http://192.168.1.9/apihm"; // IP mặc định nếu không tìm thấy
}
