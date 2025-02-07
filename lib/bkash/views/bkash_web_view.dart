import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BkashWebView extends StatefulWidget {
  final String url;
  final String successURL;
  final String failureURL;
  final String cancelURL;

  const BkashWebView({
    super.key,
    required this.url,
    required this.successURL,
    required this.failureURL,
    required this.cancelURL,
  });

  @override
  State<BkashWebView> createState() => _BkashWebViewState();
}

class _BkashWebViewState extends State<BkashWebView> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("bKash Payment")),
      body: Stack(
        children: [
          //
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              if (url == null) return;
              String urlStr = url.toString();

              if (urlStr.startsWith(widget.successURL)) {
                Fluttertoast.showToast(msg: "Payment Successful!");
                Navigator.pop(context, "success");
              } else if (urlStr.startsWith(widget.failureURL)) {
                Fluttertoast.showToast(msg: "Payment Failed!");
                Navigator.pop(context, "failure");
              } else if (urlStr.startsWith(widget.cancelURL)) {
                Fluttertoast.showToast(msg: "Payment Cancelled!");
                Navigator.pop(context, "cancel");
              }
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
          ),

          isLoading ? const LinearProgressIndicator() : Container(),
        ],
      ),
    );
  }
}
