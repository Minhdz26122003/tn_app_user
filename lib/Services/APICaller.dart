import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_hm/Global/GlobalValue.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:http/http.dart' as http;

class APICaller {
  static APICaller _apiCaller = APICaller();
  static String BASE_URL = "http://192.168.1.7/apihm/User/";
  // static String BASE_URL = "http://10.0.2.2/apihm/User/";
  // static late String BASE_URL;

  static APICaller getInstance() {
    _apiCaller ??= APICaller();
    return _apiCaller;
  }

  // static Future<void> init() async {
  //   BASE_URL = await getLocalIP();
  //   print("API URL: $BASE_URL");
  // }

  Future<dynamic> get(String endpoint, {dynamic body}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    Uri uri = Uri.parse(BASE_URL + endpoint);
    final finalUri = uri.replace(queryParameters: body);

    final response = await http
        .get(finalUri, headers: requestHeaders)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response(
          'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
    });
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .post(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        Utils.showSnackBar(
            title: 'Thông báo',
            message: jsonDecode(response.body)['error']['message']);
      }
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postFile(
      {required String endpoint,
      required File filePath,
      required String type,
      required String keyCert,
      required String time}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('ImageFiles', filePath.path));
    request.fields['Type'] = type;
    request.fields['keyCert'] = keyCert;
    request.fields['time'] = time;
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postFiles(String endpoint, List<File> filePath) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('POST', uri);
    List<http.MultipartFile> files = [];
    for (File file in filePath) {
      var f = await http.MultipartFile.fromPath('files', file.path);
      files.add(f);
    }
    request.files.addAll(files);
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
//     title: TextByNation.getStringByKey('notification'),
//     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .put(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> putFile(
      {required String endpoint, required File filePath}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('PUT', uri);
    request.files
        .add(await http.MultipartFile.fromPath('FileData', filePath.path));
    request.fields['Type'] = '1';
    request.fields['KeyCert'] = 'string';
    request.fields['Time'] = 'string';
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .delete(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }
}
