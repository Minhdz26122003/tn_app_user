import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VnPayWebViewPage extends StatefulWidget {
  final String url;
  const VnPayWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  State<VnPayWebViewPage> createState() => _VnPayWebViewPageState();
}

class _VnPayWebViewPageState extends State<VnPayWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.contains('return_url.php')) {
              final isSuccess =
                  Uri.parse(url).queryParameters['vnp_ResponseCode'] == '00';
              Navigator.of(context).pop(isSuccess);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán VNPAY')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
