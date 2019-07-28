import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String  url;

  WebViewExample({this.url});

//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: const Text('玩你妹哦'),
//        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
//        actions: <Widget>[const SampleMenu()],
//      ),
//      body: new WebView(
//        initialUrl: url,
//        javascriptMode: JavascriptMode.unrestricted,
//      ),
//    );
//  }

  @override
  State<StatefulWidget> createState() {

    return new WebviewDemo(url1:url);
  }
}

class WebviewDemo extends State<WebViewExample> {

 final String url1;


  WebviewDemo({this.url1});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('玩你妹哦'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[const SampleMenu()],
      ),
      body: new WebView(
        initialUrl: url1,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );;;
  }

}

class SampleMenu extends StatelessWidget {
  const SampleMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('You selected: $value')));
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        const PopupMenuItem<String>(
          value: 'Item 1',
          child: Text('Item 1'),
        ),
        const PopupMenuItem<String>(
          value: 'Item 2',
          child: Text('Item 2'),
        ),
      ],
    );
  }
}
