import 'package:flutter/material.dart';


class TextTranslateWidget extends StatefulWidget {
  @override
  _TextTranslateWidgetState createState() => _TextTranslateWidgetState();
}

class _TextTranslateWidgetState extends State<TextTranslateWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.green,
    );
  }
}

Widget bottomWidget() {
  var bottomWidget = new Container(
    child: new Row(
      children: <Widget>[
        RaisedButton(
          splashColor: Colors.transparent,
          color: Colors.red[300],
          onPressed: () {},
          child: new Center(
            child: new Row(
              children: <Widget>[
                Icon(Icons.phone_bluetooth_speaker),
                Text("英语"),
              ],
            ),
          ),
        ),
        RaisedButton(
          splashColor: Colors.transparent,
          color: Colors.red[300],
          onPressed: () {},
          child: new Center(
            child: new Row(
              children: <Widget>[
                Icon(Icons.phone_bluetooth_speaker),
                Text("中文"),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
