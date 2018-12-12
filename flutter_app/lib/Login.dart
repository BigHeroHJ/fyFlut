import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:flutter_app/NotificationStream.dart';
//import 'NotificationStream.dart';



final titleColor1 = Color.fromRGBO(132, 153, 181, 1);
final Duration _timerDuration = new Duration(seconds: 1);
int timerCount = 0;
RestartableTimer timer;

class LoginWidget extends StatefulWidget {
  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  LoginWidgetState();

  NotificationStreamManager mann = NotificationStreamManager.instance;
  

  TextEditingController _textEditingControllerPhone =
      new TextEditingController(); //控制textfiled
  
  TextEditingController _textEditingControllerCertify =
      new TextEditingController();

  String countryNum = "86";
  String countryName = "中国大陆";
  String certiNum = ""; //验证码

  bool isPhoneRight = false;
  bool queryCertifValid = false;

  bool loginVaild = false;
  bool loginTap = false;
  bool isWechatShow = true;

  String timerTitle = "获取验证码";
  MethodChannel channel = new MethodChannel("Login_flutter");

  @override
  initState(){
    super.initState();
  }
  
  bool _checkPhoneNumVailid(String phone) {
    // bool flag = new RegExp("/^1[34578]\d{9}\$/").hasMatch(phone);
    String source = "^[0-9]*\$";
    return new RegExp(source).hasMatch(phone);
  }

// 原生去调用 获取验证码
  void _navtiveGetCertifNum() async {
    Map params = {
      "countryNum": countryNum,
      "countryName": countryName,
      "phoneNum": _textEditingControllerPhone.text,
    };
    var result =
        await channel.invokeMethod("queryCertifyNum", params); // 调发送验证码
    print(result);
    if (result == true) {
      //开始计时60s
      timer = new RestartableTimer(_timerDuration, () {
        print(timerCount);
        timerCount++;
        setState(() {
          if (timerCount >= 60) {
            timerTitle = "获取验证码";
            queryCertifValid = true;
          } else {
            timerTitle = (60 - timerCount).toString() + "S";
            queryCertifValid = false;
            timer.reset();
          }
        });
      });
    }
  }

  void _checkInputValid() {
    setState(() {
      if (_textEditingControllerCertify.text.length != 0 &&
          _textEditingControllerPhone.text.length != 0) {
        loginVaild = true;
        print("检查输入合法");
      } else {
        loginVaild = false;
      }
    });
  }

  void _login() async {
    Map params = {
      "phoneNumber": _textEditingControllerPhone.text,
      "certifyNum": _textEditingControllerCertify.text,
    };
    dynamic result = await channel.invokeMethod("login", params);
    if (result == true) {
      print("login success");
      print(result.toString());
      NotificationStreamManager.instance.postStreamByKey("loginSuccess", true);
    }
  }

  void wechatLogin() async {
    dynamic result = await channel.invokeMethod("weChatLogin");
    if (result == true) {
      NotificationStreamManager.instance.postStreamByKey("loginSuccess", true);
    }
  }

  void isWeChatHadLogin() async {
    dynamic result = await channel.invokeMethod("jdgeWechatisLogined");
    setState(() {
      if (result) {
       isWechatShow = false;
      } else {
        isWechatShow = true;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);

    var topExplain = new Row(
      children: <Widget>[
        new Expanded(
            child: new Container(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "欢迎登陆讯飞翻译账号",
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "登陆即视为自动注册",
                style: TextStyle(
                  fontSize: 14.0,
                  color: titleColor1,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        )),
        new GestureDetector(
          child: Text(
            "讯飞翻译账号？",
            style: TextStyle(
              color: Colors.blue[200],
              fontSize: 13.0,
            ),
          ),
          onTap: () {},
        ),
      ],
    );

    var chooseCountry = new Container(
      color: Colors.white,
      child: new Row(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Text(
              "国家地区",
              style: TextStyle(
                fontSize: 15,
                color: titleColor1,
              ),
            ),
          ),
          new Expanded(
            // width: 100,
            //padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
            child: new Container(
              padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Expanded(
                    child: Text(
                      "中国大陆",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    var phone = new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(
            left: 5,
          ),
          child: Icon(Icons.phone_iphone),
        ),
        new Padding(
          padding: EdgeInsets.only(
            left: 10,
          ),
          child: Text("+86",
              style: TextStyle(
                fontSize: 15,
                color: titleColor1,
              )),
        ),
        new Expanded(
          child: new Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20, top: 1, bottom: 1),
            child: TextField(
              controller: _textEditingControllerPhone,
              onChanged: (String changeStr) {
                setState(() {
                  if (_checkPhoneNumVailid(changeStr) == true) {
                    isPhoneRight = true;
                    queryCertifValid = true;
                    print("phone is true");
                  } else {
                    print("phone is false");
                    isPhoneRight = false;
                  }
                });
              },
              decoration: new InputDecoration(
                hintText: "请输入手机号",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 17.0,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
              ),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              //autofocus: true,//自动聚焦
            ),
          ),
        ),
      ],
    );

    var certy = new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(
            left: 5,
          ),
          child: Icon(Icons.security),
        ),
        new Expanded(
          child: new Container(
            height: 50,
            padding: EdgeInsets.only(left: 60, top: 1, bottom: 1),
            child: TextField(
              onChanged: (String txt) {
                _checkInputValid();
              },
              controller: _textEditingControllerCertify,
              decoration: InputDecoration(
                hintText: "请输入验证码",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 17.0,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
              ),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            ),
          ),
        ),
        new Container(
            constraints: new BoxConstraints.expand(width: 100, height: 30),
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 5),
            child: new Container(
              child: new Theme(
                data: Theme.of(context).copyWith(
                    buttonTheme: new ButtonThemeData(
                  // minWidth: 10,
                  // height: 10,
                  // buttonColor: Colors.red,
                  padding: EdgeInsets.all(
                      0), //可以通过 一个theme 给sub widget 覆盖一写默认属性 或者直接在每一个button 中写 ，这种theme 可以给一系列的按钮加同一种样式
                )),
                child: new OutlineButton(
                  child: new Text(
                    timerTitle,
                    // style: TextStyle(color: Colors.blue),
                  ),
                  // splashColor: Colors.transparent,
                  // highlightColor: Colors.transparent,
                  textColor: Colors.blue,
                  disabledTextColor: Colors.red,
                  disabledBorderColor: Colors.red,
                  borderSide: new BorderSide(
                    color: Colors.blue,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  onPressed: isPhoneRight && queryCertifValid
                      ? () {
                          print("可以获取验证码");
                          _navtiveGetCertifNum();
                        }
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25),
                  ),
                ),
              ),
            )
            // child: new CupertinoButton(
            //   padding: EdgeInsets.all(0),//默认是有16pixel 的
            //   borderRadius: BorderRadius.all(Radius.circular(2 )),
            //   onPressed: () {},
            //   disabledColor: Colors.red,
            //   child: new Container(
            //     child: Text(
            //       "获取验证码",
            //       style: TextStyle(
            //         color: Colors.grey,
            //       ),
            //     ),
            //   ),
            // ),
            ),
      ],
    );

    var phoneNumWidget = new Container(
      padding: EdgeInsets.only(top: 20),
      child: new Container(
        color: Colors.white,
        child: new Column(
          children: <Widget>[
            phone,
            new Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: new Divider(
                height: 1,
                color: Colors.blue,
              ),
            ),
            certy,
          ],
        ),
      ),
    );

    var loginWidget = new Expanded(
        child: new Column(
      children: <Widget>[
        FlatButton(
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          onPressed: loginVaild
              ? () {
                  print("click tap");
                  _login();
                  NotificationStreamManager.instance.postStreamByKey("loginSuccess", true);
                }
              : null,

          padding: EdgeInsets.only(top: 60),
          child: new Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Image.asset(
                loginTap ? "assets/but-selected.png" : "assets/but-normal.png",
                fit: BoxFit.scaleDown,
                width: MediaQuery.of(context).size.width * 0.9,
                height: 80,
              ),
              new Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "登录",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));

    var wechatWidget = new Container(
      margin: EdgeInsets.only(bottom: 40),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 1,
                  color: Colors.grey,
                ),
                Text("其他登录方式"),
                new Container(
                  height: 1,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  color: Colors.grey,
                )
              ],
            ),
            padding: EdgeInsets.only(bottom: 30.0),
          ),
          Image.asset(
            "assets/ico-wechat-nor_login.png",
            width: 45,
            height: 45,
            fit: BoxFit.contain,
          ),
          new Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "微信",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 17.0,
              ),
            ),
          )
        ],
      ),
    );

    return new Scaffold(
      backgroundColor: Color.fromRGBO(241, 249, 255, 1),
      body: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[ 
          topExplain,
          chooseCountry,
          phoneNumWidget,
          loginWidget,
          isWechatShow? wechatWidget : new Container(),
        ],
      ),
    );
  }
}
