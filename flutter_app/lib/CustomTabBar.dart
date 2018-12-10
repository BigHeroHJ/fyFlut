import 'package:flutter/material.dart';


typedef CustomBarPress = void Function(int idx);


class CustomAppBarWidget extends StatefulWidget {
  int currentIndex;
  List<String> titles = new List();

  @override CustomAppBarState createState() => CustomAppBarState();

  CustomBarPress onpress;

  CustomAppBarWidget(this.currentIndex,{this.onpress,this.titles});
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
          width: 100,
          height: 5,
          constraints: BoxConstraints(),
          child: new Divider(
            color: Colors.blue,
            height: 5,
          ),
        ),
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