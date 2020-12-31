import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BrowserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InAppWebView(
        initialUrl: "https://google.com/",
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            debuggingEnabled: true,
          ),
        ),
      ),
    );
  }
}
