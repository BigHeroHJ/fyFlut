import 'package:flutter/material.dart';
import 'audio.dart';
import 'package:flutter/scheduler.dart';
import 'package:flare_flutter/flare_actor.dart';

class AudioTranslateWidget extends StatefulWidget {
  @override
  _AudioTranslateWidgetState createState() => _AudioTranslateWidgetState();
}

class _AudioTranslateWidgetState extends State<AudioTranslateWidget> {
  List<AudioTransModel> listMessage = new List();

  ScrollController _scrollController =
      new ScrollController(keepScrollOffset: true);
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.red,
      child: new Column(
        children: <Widget>[
//          new Container(
//            color: Colors.blue,
//            child: FlareActor("assets/New File.flr", // You can find the example project here: https://www.2dimensions.com/a/castor/files/flare/change-color-example
//              fit: BoxFit.contain, alignment: Alignment.center,animation: "changeColor",),
//            constraints: BoxConstraints.expand(width: 100, height: 50),
//          ),
           new Expanded(child: buildTransTable()),
           bottomWidget(),
        ],
      ),
    );
  }

  sendMessage(bool isCN) {
    AudioTransModel model = AudioTransModel();
    model.transText = "我的饿过";
    model.oriTrans = "我的饿过";
    model.isCN = isCN;
    setState(() {
      listMessage.add(model);
//      _scrollController.animateTo(
//      _scrollController.position.maxScrollExtent + 20,
//        curve: Curves.easeOut,
//        duration: const Duration(milliseconds: 300),
//      );
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  buildMessage(BuildContext context, int index) {
    AudioTransModel model = listMessage[index];
    var message;
    if (model.isCN) {
      //右边
      message = new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            //???本来这个Container 是可以根据子空间大小伸缩的，在listview.builder 中不行要warp在row 中才可以？？？
            child: Text(
              model.transText,
              style: TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            constraints: BoxConstraints(
                minHeight: 40,
                minWidth: 60,
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            margin: EdgeInsets.only(bottom: 10.0, right: 20, left: 20),
          ),
        ],
      );
    } else {
      //左边
      message = new Row(
        children: <Widget>[
          Container(
            child: Text(
              model.oriTrans,
              style: TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(8.0)),
            constraints: BoxConstraints(
                minHeight: 40,
                minWidth: 60,
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            margin: EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
          ),
        ],
      );
    }
    return message;
  }

  //列表build
  Widget buildTransTable() {
    return new RefreshIndicator(
        child:  ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return buildMessage(context, index);
          },
          itemCount: listMessage.length,
          controller: _scrollController,
//      reverse: true,
//      shrinkWrap: true,
        ),
        onRefresh: (){
          print("refresh");
        });
  }

//底部按钮
  Widget bottomWidget() {
    var bottomWidget = new Container(
      color: Colors.white,
      constraints: BoxConstraints(minHeight: 130),
      child: new Row(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              splashColor: Colors.transparent,
              color: Colors.red[300],
              onPressed: () {
                sendMessage(false);
              },
              child: new Center(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.phone_bluetooth_speaker),
                    ),
                    Text("英语"),
                  ],
                ),
              ),
            ),
          )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              splashColor: Colors.transparent,
              color: Colors.red[300],
              onPressed: () {
                sendMessage(true);
              },
              child: new Center(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.phone_bluetooth_speaker),
                    ),
                    Text("中文"),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
    return bottomWidget;
  }
}
