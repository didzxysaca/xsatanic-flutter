import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Fullscreen immersive
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const XSatanicApp());
}

class XSatanicApp extends StatelessWidget {
  const XSatanicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebContainer(),
    );
  }
}

class WebContainer extends StatefulWidget {
  const WebContainer({super.key});

  @override
  State<WebContainer> createState() => _WebContainerState();
}

class _WebContainerState extends State<WebContainer> {
  InAppWebViewController? _controller;

  // Hide URL (split string)
  String buildUrl() {
    return "https"
        "://"
        "xsat"
        "anic"
        ".dxy"
        "vxz"
        ".my"
        ".id";
  }

  Future<bool> _onWillPop() async {
    if (_controller != null && await _controller!.canGoBack()) {
      _controller!.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(buildUrl()),
            headers: {
              "Cache-Control": "max-age=86400",
            },
          ),
          initialSettings: InAppWebViewSettings(
            // BASIC
            javaScriptEnabled: true,
            domStorageEnabled: true,
            allowsInlineMediaPlayback: true,
            mediaPlaybackRequiresUserGesture: false,
            supportZoom: false,

            // CACHE (KUNCI PRELOAD)
            cacheEnabled: true,
            horizontalScrollBarEnabled: false,
            verticalScrollBarEnabled: false,
            clearCache: false,
            clearSessionCache: false,

            // ANDROID CACHE MODE (INI YANG PENTING)
            cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,

            // VISUAL
            transparentBackground: true,
          ),
          onWebViewCreated: (controller) async {
            _controller = controller;

            // Trigger preload supaya cache kepakai cepat
            await _controller!.loadUrl(
              urlRequest: URLRequest(url: WebUri(buildUrl())),
            );
          },
          androidOnPermissionRequest:
              (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
        ),
      ),
    );
  }
}
