import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/widget/articleWidget.dart';
import 'package:flutter_wanandroid/widget/projectWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '玩 Android'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin<MyHomePage>{
  int _counter = 0;

  ArticleWidget articleWidget =  new ArticleWidget();
  ProjectsWidget projectsWidget = new ProjectsWidget();

  final List<Tab> _tabs = <Tab>[
    new Tab(text: '最新博文',),
    new Tab(text: '最新项目'),
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            bottom: new TabBar(
              tabs: [new Tab(text: '最新博文'), new Tab(text: '最新项目')],
              isScrollable: false,
              labelStyle: TextStyle(fontSize: 16.0),
              unselectedLabelStyle: TextStyle(fontSize: 16.0),
            ),
          ),
          body: new TabBarView(
              children: _tabs.map((Tab tab) {
                if (tab.text.contains('博文')) {
                  return  articleWidget;
                } else {
                  return  projectsWidget;
                }
          }).toList()),
//          floatingActionButton: FloatingActionButton(
//            onPressed: _incrementCounter,
//            tooltip: 'Increment',
//            child: Icon(Icons.add),
//          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  bool get wantKeepAlive => true;
}
