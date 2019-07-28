import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/beans/newProject.dart';
import 'package:flutter_wanandroid/webview.dart';
import 'package:flutter_wanandroid/widget/RefreshAndLoadWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProjectsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _projectState();
  }
}

class _projectState extends State<ProjectsWidget>
    with AutomaticKeepAliveClientMixin {
  List<Datas> widgets = new List();
  var page = 0;
  RefreshAndLoadControl refreshAndLoadControl = new RefreshAndLoadControl();

  getProjectlist() async {
    var httpClient = new HttpClient();
    var uri = new Uri.http('wanandroid.com', '/article/listproject/$page/json',
        {'param1': '42', 'param2': 'foo'});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    Projects listRes = Projects.fromJson(data);
    if (page==0) {
      widgets.clear();
    }
//    widgets = listRes.data.datas;
    widgets.addAll(listRes.data.datas);
    Fluttertoast.showToast(msg: "请求成功page$page");

    Fluttertoast.showToast(msg: "${listRes.data.datas.length}条");

    try {
      if (listRes.data.datas.length>=15) {

            refreshAndLoadControl.needLoadMore = true;
          } else{
            refreshAndLoadControl.needLoadMore = false;
          }
    } catch (e) {
      print(e);
      refreshAndLoadControl.needLoadMore = false;
    }
    setState(() {
//      widgets;
    });
    print(listRes);
  }

  @override
  void initState() {
    super.initState();
    print(' _projectState initState');
    getProjectlist();
  }

  Widget getRow(BuildContext context, int i) {
    return new GestureDetector(
      child: new Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        height: 80.0,
        padding: new EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            SizedBox(
              width: 72.0,
              height: 144.0,
              child: Image.network(widgets.elementAt(i).envelopePic),
            ),
            SizedBox(
              height: 80.0,
              width: 260.0,
              child: new Text(
                "${widgets.elementAt(i).title})",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new WebViewExample(url: widgets.elementAt(i).link)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
//    return new ListView.builder(
//        itemCount: widgets.length,
//        itemBuilder: (BuildContext content, int position) {
//          return getRow(context ,position);
//        });
    refreshAndLoadControl.dataList = widgets;
    return RefreshAndLoadWidget(
        refresh, loadmore, getRow, refreshAndLoadControl);
  }

  Future<Null> refresh() {
    print("refresh");
    page=0;
    getProjectlist();
    return null;
  }

  Future<Null> loadmore() {
    print("loadmore");
    page++;
    getProjectlist();

    return null;
  }

  @override
  bool get wantKeepAlive => true;
}
