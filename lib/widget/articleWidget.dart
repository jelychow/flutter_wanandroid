import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/beans/articles.dart';
import 'package:flutter_wanandroid/webview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _articleState();
  }
}

class _articleState extends State<ArticleWidget> with AutomaticKeepAliveClientMixin{
  List<Datas> widgets = [];

  getProjectlist() async {
    var httpClient = new HttpClient();
    var uri = new Uri.http('wanandroid.com', '/article/list/1/json',
        {'param1': '42', 'param2': 'foo'});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    print(responseBody);
    Map data = json.decode(responseBody);
    Articles listRes = Articles.fromJson(data);
    widgets = listRes.data.datas;
    setState(() {
      widgets;
    });
    print(listRes);
  }

  @override
  void initState() {
    super.initState();
    print(' _articleState initState');

    getProjectlist();
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor))),
          height: 150.0,
          padding: new EdgeInsets.all(10.0),
          child: new Row(
            children: <Widget>[
              SizedBox(
                width: 76.0,
                height: 144.0,
                child: Image.network(widgets.elementAt(i).envelopePic),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15.0),
                padding: const EdgeInsets.only(top: 10.0),
                height: 150.0,
                width: 240.0,
                child: Column(
                  children: <Widget>[
                    new Text(
                      "${widgets.elementAt(i).title})",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        "${widgets.elementAt(i).niceDate}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(fontSize: 18.0,color: Colors.grey),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
      onTap: () {
        print(widgets.elementAt(i).link);
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
        new WebviewScaffold(
          url:  widgets.elementAt(i).link,
          appBar: new AppBar(
            title: new Text("Widget webview"),
          ),
        )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext content, int position) {
          return getRow(position);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
