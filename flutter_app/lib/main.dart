import 'package:flutter/material.dart';
import 'package:flutter_app/AudioTranslate.dart';
import 'package:flutter_app/TextTranslate.dart';

import 'config.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare.dart';


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

  int _currentPage = 0;
  PageController  _pageController = new PageController(initialPage: 0,);

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn){
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

//    new NotificationListener(child: this.widget,onNotification:(NotifiPage noti){
//      setState(() {
//        _currentPage = noti.currentPageIndex;
//      });
//    },);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomAppBarWidget(_currentPage,onPress: (int pageIndex){
            setState((){
              _pageController.animateToPage(pageIndex, duration: Duration(microseconds: 550), curve: Curves.easeInOut);
            });
        },) ,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: Center(
        child: PageView(
          controller: _pageController,
          children: <Widget>[
            AudioTranslateWidget(),
            TextTranslateWidget(),
          ],
          onPageChanged: (int pageIndex){
            setState(() {
              _currentPage = pageIndex;
            });
          },
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

typedef CustomBarPress = void Function(int idx);

class CustomAppBarWidget extends StatefulWidget {
  int currentIndex;
  @override CustomAppBarState createState() => CustomAppBarState();

  CustomBarPress onpress;

  CustomAppBarWidget(int currentIndex,{onPress:CustomBarPress}){
    this.currentIndex = currentIndex;
     if (onPress != null){
       this.onpress = onPress;
     }
  }
}

class CustomAppBarState extends State<CustomAppBarWidget> {

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
                splashColor: Colors.transparent,
                color: Colors.transparent,
                textColor:this.widget.currentIndex == 0? Colors.blue : Colors.black,
                highlightColor: Colors.transparent,
                onPressed: () {
//                  new NotifiPage(1).dispatch(context);
                  setState((){
                    this.widget.onpress(0);
                  });
                },
                child: Text(
                  "语音翻译",
                  style: TextStyle(fontSize: 15),
                ),
                padding: EdgeInsets.all(0)),
            FlatButton(
                splashColor: Colors.transparent,
                textColor:this.widget.currentIndex == 1? Colors.lightBlue : Colors.black,
                highlightColor: Colors.transparent,
                onPressed: () {
//                  new NotifiPage(2).dispatch(context);
                  setState((){
                    this.widget.onpress(1);
                  });
                },
                child: Text("文本翻译", style: TextStyle(fontSize: 15)),
                padding: EdgeInsets.all(0)),
          ],
        ),

        new Container(
          decoration: new UnderlineTabIndicator(
          ),
          width: 150,
          height: 5,
          constraints: BoxConstraints(),
          child: new Divider(
            color: Colors.blue,
            height: 5,
          ),
        )
//        new AnimatedPositioned(child: new Container(
//          decoration: new UnderlineTabIndicator(
//          ),
////          width: 20,
////          height: 1,
////          constraints: BoxConstraints(),
////          child: new Divider(
////            color: Colors.blue,
////            height: 1,
////          ),
//        ), duration: Duration(microseconds: 500),curve: Curves.easeInOut,),

//        new AnimatedContainer(duration: Duration(microseconds: 500),child: new Positioned(
//          width: 90,
//          height: 1,
//          bottom: 1,
//          child: new Divider(
//            color: Colors.blue,
//            height: 1,
//          ),
//        ),),
      ],
    );
  }
}

//class NotifiPage  extends Notification{
//  int currentPageIndex;
//  NotifiPage(int currentPageIndex);
//}

//appbar
//class CustomAppBarWidget extends InheritedWidget {
//  @override
//  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
//}

//class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
//
//  @override
//  Widget build(BuildContext context) {
//    //return Text("语音翻译文本翻译");
//    return Stack(
//      children: <Widget>[
//        new Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            FlatButton(
//              splashColor: Colors.transparent,
//                color: Colors.transparent,
//                textColor: Colors.black,
//                highlightColor: Colors.lightBlue,
//                onPressed: () {},
//                child: Text(
//                  "语音翻译",
//                  style: TextStyle(fontSize: 15),
//                ),
//                padding: EdgeInsets.all(0)),
//            FlatButton(
//              splashColor: Colors.transparent,
//                textColor: Colors.black,
//                highlightColor: Colors.lightBlue,
//                onPressed: () {},
//                child: Text("文本翻译", style: TextStyle(fontSize: 15)),
//                padding: EdgeInsets.all(0)),
//          ],
//        ),
//        new Positioned(
//          width: 90,
//          height: 1,
//          bottom: 1,
//          child: new Divider(
//            color: Colors.blue,
//            height: 1,
//          ),
//        ),
//      ],
//    );
//  }
//}
