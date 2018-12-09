import 'package:flutter/material.dart';
import 'package:flutter_app/AudioTranslate.dart';
import 'package:flutter_app/TextTranslate.dart';

import 'config.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: defaultTheme(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomAppBarWidget(),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: FlareActor("asserts/Penguin.flr", // You can find the example project here: https://www.2dimensions.com/a/castor/files/flare/change-color-example
          fit: BoxFit.contain, alignment: Alignment.center),
//      body: Center(
//        child: PageView(
//          children: <Widget>[
//            AudioTranslateWidget(),
//            TextTranslateWidget(),
//          ],
//        ),
//      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//appbar
class CustomAppBarWidget extends StatefulWidget {
  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    //return Text("语音翻译文本翻译");
    return Stack(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
              splashColor: Colors.transparent,
                color: Colors.transparent,
                textColor: Colors.black,
                highlightColor: Colors.lightBlue,
                onPressed: () {},
                child: Text(
                  "语音翻译",
                  style: TextStyle(fontSize: 15),
                ),
                padding: EdgeInsets.all(0)),
            FlatButton(
              splashColor: Colors.transparent,
                textColor: Colors.black,
                highlightColor: Colors.lightBlue,
                onPressed: () {},
                child: Text("文本翻译", style: TextStyle(fontSize: 15)),
                padding: EdgeInsets.all(0)),
          ],
        ),
        new Positioned(
          width: 90,
          height: 1,
          bottom: 1,
          child: new Divider(
            color: Colors.blue,
            height: 1,
          ),
        ),
      ],
    );
//    return new Center(
//      child: Text("语音翻译文本翻译"),
//      child:  new Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Text("语音翻译"),
//          Text("文本翻译"),
//        ],
//      ),
//      );
  }
}
