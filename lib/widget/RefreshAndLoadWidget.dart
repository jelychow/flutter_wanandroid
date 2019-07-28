import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/widget/custom_bouncing_scroll_physics.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RefreshAndLoadWidget extends StatefulWidget {
  final RefreshCallback onRefresh;
  final RefreshCallback onRLoadMore;
  final IndexedWidgetBuilder builder;
  final RefreshAndLoadControl refreshAndLoadControl;
  ScrollController controller;

  @override
  State<StatefulWidget> createState() {
    return _RefreshAndLoadWidgetState();
  }

  RefreshAndLoadWidget(this.onRefresh, this.onRLoadMore, this.builder,
      this.refreshAndLoadControl);
}

class _RefreshAndLoadWidgetState extends State<RefreshAndLoadWidget>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = new ScrollController();

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInSine,
    );
    _scrollController.addListener(() {
//      Fluttertoast.showToast(msg: "123");
      print("pixels" + _scrollController.position.pixels.toString());
      print("maxScrollExtent" +
          _scrollController.position.maxScrollExtent.toString());

      ///判断当前滑动位置是不是到达底部，触发加载更多回调
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
//        Fluttertoast.showToast(msg: ""+(this.widget.refreshAndLoadControl.needLoadMore.value.toString()));
//        print("position" +
//            widget.refreshAndLoadControl.needLoadMore.value.toString());

        if (this.widget.refreshAndLoadControl.needLoadMore) {
          Fluttertoast.showToast(
              msg: "boolean" +
                  "${(this.widget.refreshAndLoadControl.needLoadMore)}");

          handleLoadMore();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: handleRefresh,
          builder: buildSimpleRefreshIndicator,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return _getItem(index);
          }, childCount: widget.refreshAndLoadControl.dataList.length + 1)),
        )
      ],
    ));
  }

  Widget buildSimpleRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    /*if(refreshState == IOS.RefreshIndicatorMode.refresh) {
      onRefreshing();
    } else {
      onRefreshEnd();
    }*/
//    refreshState == RefreshIndicatorMode.refresh;

    const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);

    print("state:${pulledExtent}");
//   return Opacity(
//     opacity: opacityCurve.transform(
//         min(pulledExtent / refreshIndicatorExtent, 1.0)
//     ),
//     child: const CupertinoActivityIndicator(radius: 14.0),
//   );
    return  Container(
            height: pulledExtent > 120 ? pulledExtent : 120,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  height: 30,
                  child:(_scrollController.position.pixels<-40)
                      ? m.CircularProgressIndicator()
                      : new Container(),
                )
              ],
            ));
  }

  Widget _getItem(int index) {
    if (index == widget.refreshAndLoadControl._dataList?.length) {
      return _buildLoadMoreIndicator();
    } else {
      return widget.builder(context, index);
    }
//    return Text("$index");
  }

  Widget _buildLoadMoreIndicator() {
    Widget bottom = widget.refreshAndLoadControl.needLoadMore
        ? Text("正在加载中。。。")
        : Text("加载完毕");

    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: bottom,
        ));
  }

  Future<Null> handleRefresh() async {
    widget.onRefresh?.call();
    await doDelayed();

    return null;
  }

  Future<Null> handleLoadMore() async {
    Fluttertoast.showToast(msg: "handleLoadMore");
    widget.onRLoadMore?.call();
    return null;
  }

  doDelayed() async {
    await Future.delayed(Duration(seconds: 2)).then((_) async {
      return null;
    });
  }
}

class RefreshAndLoadControl extends ChangeNotifier {
  List _dataList = new List();

  get dataList => _dataList;

  set dataList(List value) {
    _dataList.clear();
    if (value != null) {
      _dataList.addAll(value);
      notifyListeners();
    }
  }

  bool _needLoadMore = true;

  get needLoadMore => _needLoadMore;

  set needLoadMore(bool value) {
    _needLoadMore = value;
    notifyListeners();
  }
}
