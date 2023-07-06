import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/providers/login/login_state.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EclassWebview extends StatefulWidget {
  const EclassWebview({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<EclassWebview> createState() => _EclassWebviewState();
}

class _EclassWebviewState extends State<EclassWebview> {
  bool isLoading = true;

  late WebViewController _webViewController;
  @override
  void initState() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) {
        if (mounted) {
          setState(() {
            isLoading = false;
            _webViewController.setBackgroundColor(Colors.white);
          });
        }
      }))
      ..loadRequest(
        Uri.parse(widget.url),
        headers: {'cookie': context.read<LoginState>().moodlesession},
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeState>();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: themeState.systemUiOverlayStyle,
        leading: CupertinoButton(
          child: Icon(
            Icons.chevron_left_rounded,
            color: themeState.fontColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(opacity: 0.7),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          isLoading
              ? Center(child: spinkitfadingcircle())
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
