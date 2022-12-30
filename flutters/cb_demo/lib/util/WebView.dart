import 'dart:async';

import 'package:cb_demo/routes/Routes.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String? url;

  const CustomWebView(this.url, {Key? key}) : super(key: key);

  @override
  State<CustomWebView> createState() => _CustomWebViewState(url);
}

class _CustomWebViewState extends State<CustomWebView> {
  String? url;
  String _title = "";
  _CustomWebViewState(this.url);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late Set<JavascriptChannel> javascriptChannels;

  @override
  void initState() {
    super.initState();

    javascriptChannels = Set();
    javascriptChannels.add(JavascriptChannel(
        name: "title",
        onMessageReceived: (info) {
          print("WebView JS Channel ${info.message}");
        }));

    url ??= "https://blog.csdn.net/TuGeLe/article/details/104004692";

    _controller.future.whenComplete(() => print("WebView whenComplete"));
    _controller.future.then((value) => value.loadUrl(url!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future<String> title;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            _title,
            style: mediumStyle(fontSize: 16, color: const Color(0xFF333333)),
          ),
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back,
                size: 20,
              )),
          actions: [
            IconButton(
              onPressed: () => print("分享"),
              icon: const Icon(
                Icons.share,
                size: 20,
                color: Color(0xFF333333),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: WebView(
            onWebViewCreated: (controller) =>
                {_controller.complete(controller)},
            //initialUrl: url!,
            //initialCookies: [],
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: javascriptChannels,
            navigationDelegate: (request) {
              return NavigationDecision.navigate;
            },
            gestureRecognizers: null,
            onPageStarted: (url) => print("WebView page start $url"),
            onPageFinished: (url) {
              print("WebView page finish $url");
              _controller.future.then(
                  (value) => value.getTitle().then((value) => setState(() {
                        _title = value ??= "title";
                      })));
            },
            onProgress: (v) => print("WebView page progress $v"),
            onWebResourceError: (error) =>
                print("WebView Resource error $error"),
            debuggingEnabled: false,
            gestureNavigationEnabled: false,
            userAgent: null,
            zoomEnabled: true,
            initialMediaPlaybackPolicy:
                AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
            allowsInlineMediaPlayback: false,
            backgroundColor: Colors.white,
          ),
        ));
  }
}
