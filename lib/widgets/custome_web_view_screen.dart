import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomeWebViewScreen extends StatefulWidget {
  final String url;
  const CustomeWebViewScreen({super.key, required this.url});

  @override
  State<CustomeWebViewScreen> createState() => _CustomeWebViewScreenState();
}

class _CustomeWebViewScreenState extends State<CustomeWebViewScreen> {
  WebViewController? _controller;
  @override
  void initState() {
    // log('web url==>${widget.url}');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: _controller!,
      ),
    );
  }
}
