import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/NotificationStream.dart';

class AccountInfoWidget extends StatefulWidget {
  @override
  AccountInfoState createState() => AccountInfoState();
}

class AccountInfoState extends State<AccountInfoWidget> {
  MethodChannel channel =
      new MethodChannel("flutterModule_AccountInfo_channel");

  dynamic accountInfo;

  void _getAccountInfoByNative() async {
    dynamic result = await channel.invokeMethod("getAccountInfo");
    setState(() {
      accountInfo = result;
    });
  }

  void _unBindWechatAccount() async {
    dynamic result = await channel.invokeMethod("unBindWechatAccount");
  }

  @override
  void initState() {
    super.initState();
    _getAccountInfoByNative();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    //获取登录状态
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue[50],
      body: new ListView(
        children: <Widget>[
          renderRow(1),
          renderRow(2),
          new FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
               NotificationStreamManager.instance.postStreamByKey("loginSuccess", true);
            },
          ),
        ],
      ),
    );
  }

  Widget renderRow(int idx) {
    String title = "";
    String imageName = "";
    String bigTitle = "";
    String subTitle = "";

    String buttonText = "";
    TextStyle relatedTextStyle;
    BorderSide buttonBorderSide;
    bool isButtonCanClick = false;
    bool isSubtitleHid = false;

    if (accountInfo == null) {
      return new Container();
    }
    dynamic wxAccount = accountInfo["wxAccount"];
    dynamic phoneAccount = accountInfo["phoneAccount"];
    //配置样式
    if (idx == 1) {
      title = "讯飞翻译账号";
      imageName = "assets/ico_shoujihao_zhxx.png";
      bigTitle = "手机号";
      if (phoneAccount != null) {
        subTitle = "+" + phoneAccount["countryNumber"] + phoneAccount["phone"];
      } else {
        subTitle = "关联手机号可保留翻译记录";
        buttonText = "未关联";
        isButtonCanClick = true;
      }
      relatedTextStyle = new TextStyle(
        color: Colors.blue,
      );
      buttonBorderSide = BorderSide(
        color: Colors.blue,
        width: 1.0,
        style: BorderStyle.none,
      );
    } else if (idx == 2) {
      title = "其他登录方式";
      imageName = "assets/ico-weixin-zhxx.png";
      bigTitle = "微信";
      if (wxAccount != null) {
        subTitle = wxAccount["nickName"];
        relatedTextStyle = new TextStyle(
          color: Colors.grey,
        );
        buttonBorderSide = BorderSide(
          color: Colors.grey,
          width: 1.0,
          style: BorderStyle.solid,
        );
        buttonText = "已关联";
        if (phoneAccount != null) {
          isButtonCanClick = true;
        }
      } else {
        relatedTextStyle = new TextStyle(
          color: Colors.blue,
        );
        buttonBorderSide = BorderSide(
          color: Colors.blue,
          width: 1.0,
          style: BorderStyle.solid,
        );
        buttonText = "未关联";
        isButtonCanClick = true;
        isSubtitleHid = true;
      }
    }

    void _clickButton(idx) {
      if (idx == 1) {
        //关联手机号
        channel.invokeMethod("loginPhoneAccount");
      } else {
        if (wxAccount == null) {
          // 关联微信号
          channel.invokeMethod("loginWechat");
        } else {
          //点击已关联
          print("解除绑定");
          showDialog(
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
                  title: Text("确认退出吗？"),
                  content: Text("退出后将无法再使用微信账号登录"),
                  actions: <Widget>[
                    new CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text("取消"),
                    ),
                    new CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        _unBindWechatAccount();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text("确定"),
                    )
                  ],
                ),
          );
        }
      }
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
          child: Text(title),
        ),
        new Container(
          height: 70,
          color: Colors.white,
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 20),
                child: Image.asset(
                  imageName,
                  width: 30,
                  height: 30,
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, bottom: 2, right: 10),
                      child: Text(
                        bigTitle,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 2, left: 10, bottom: 10, right: 10),
                      child: isSubtitleHid
                          ? new Container()
                          : Text(
                              subTitle,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blue[100],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              new Container(
                //constraints: BoxConstraints.expand(width: 50,height: 30),
                margin: EdgeInsets.only(right: 10),
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    buttonTheme: new ButtonThemeData(
                      minWidth: 50,
                      height: 20,
                    ),
                  ),
                  child: new OutlineButton(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    onPressed: isButtonCanClick
                        ? () {
                            _clickButton(idx);
                          }
                        : null,
                    child: Text(
                      buttonText,
                      style: relatedTextStyle,
                    ),
                    textColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20),
                    ),
                    borderSide: buttonBorderSide,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
