import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget buildSplineViewer(BuildContext context, String url) {
  return _MobileSplineViewer(splineUrl: url);
}

class _MobileSplineViewer extends StatefulWidget {
  final String splineUrl;
  
  const _MobileSplineViewer({required this.splineUrl});

  @override
  State<_MobileSplineViewer> createState() => _MobileSplineViewerState();
}

class _MobileSplineViewerState extends State<_MobileSplineViewer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();

    if (!kIsWeb) {
      try {
        _controller.setBackgroundColor(Colors.transparent);
        _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
        _controller.loadRequest(Uri.parse(widget.splineUrl));
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
