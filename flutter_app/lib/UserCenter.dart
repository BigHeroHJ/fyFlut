import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model.dart';
import 'package:flutter_app/myCollection.dart';
import 'package:flutter_app/Login.dart';
import 'accountInfo.dart';
import 'NotificationStream.dart';

void main() => runApp(UserCenterAPP());

final ThemeData iOSThemeData = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.red[100],
  platform: TargetPlatform.iOS,
  backgroundColor: Colors.white,
);

const methodChannel = const MethodChannel("com.xffyFlutter.");

class UserCenterAPP extends StatelessWidget {
  Widget build(BuildContext ctx) {
    return new MaterialApp(
      theme: iOSThemeData,
      routes: {
        "main": (BuildContext context) => new UserCenterPage(),
        "myCollection":(BuildContext context) => new MyCollectionPage(),
        "about": (BuildContext context) => new LoginWidget(),
        "AccountInfo" : (BuildContext context) => new AccountInfoWidget(),
      },
      home: UserCenterPage(),
    );
  }
}

Future <dynamic> _getLoginState () async {
  final Map result = await methodChannel.invokeMethod("getLoginState");
  return result;
  // result.then((value) => (value){
  //     return value;
  // });
}

class UserCenterPage extends StatefulWidget {
  @override
  _UseCenterPageState createState() => _UseCenterPageState();
}

//??? 资源自动加载2x3x 图片 还未搞清
class _UseCenterPageState extends State<UserCenterPage> {
  //method channel
  static const methodChannel = const MethodChannel("com.xffyFlutter.");

  bool islogin = false;

  List titles = ["我的收藏","意见反馈","推荐给好友","购买翻译机","关于","给我评分"];
  List imgArr = ["assets/ico_shoucang.png","assets/ico-yijianfankui.png","assets/ico_tuijiangeihaoyou.png","assets/ico_goumai.png","assets/ico_guanyu.png","assets/ico_pinfen.png"];
  List listData = new List();

  List<Widget> widgets = new List();
  UserInfoModel userModel;

  _initListData(){
    for (int i = 0;i < titles.length; i++) {
      print(UserCenterType.values[i]);
      UserItemModel model = UserItemModel(titles[i], imgArr[i], UserCenterType.values[i]);
      listData.add(model);
    }
  }
  //获取 当前的 灰度控制参数
  _getControlArgumentFromNativeIOS() async {
    dynamic result = await methodChannel.invokeMethod("IsBuyChannelShow");//获取灰度控制参数
    setState((){
      if (widgets.length > 0) {
        if (!result) {
          setState((){
            widgets.removeAt(4);
          });
        }
      }
    });
  }

  //退出登录
  _logOut() async{
    bool result = await methodChannel.invokeMethod("loginOut");
    if (result == true) {
      setState((){
            () async {
          Map result = await _getLoginState();
          if (result != null) {
            islogin = result["isLogin"];
          }
        }();
      });
    } else {

    }
  }

  @override
  void initState() {
    super.initState();
    _initListData();
    _getControlArgumentFromNativeIOS();
    setState((){
      if (widgets.length == 0) {
        widgets = getUserCenterCountListData();
        widgets.insert(0, getUserAccountWidget());
      }
          () async {
        Map result = await _getLoginState();
        if (result != null) {
          islogin = result["isLogin"];
        }
      }();
    });
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  Widget build(BuildContext contxt) {
    NotificationStreamManager.instance.registerStream("loginSuccess");
    print(NotificationStreamManager.instance.centerMap.toString());

    return new Scaffold(
      //使用appBar自己的导航栏 切换不是很流畅 导航栏暂时用原生的切换
      // appBar: AppBar(
      //   title: Text("用户中心"),
      //   elevation: 0,
      //   leading: new IconButton(
      //     icon: new Icon(Icons.arrow_back_ios),
      //     onPressed: (){
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: new Container(
        color: Colors.white,//页面背景色
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new ListView(
                children: widgets,
              ),
            ),
            islogin? new Padding(
              padding: EdgeInsets.only(bottom: 100.0,left: 20.0,right: 20.0),
              child: new Theme(
                data: Theme.of(context).copyWith(
                  buttonTheme: new ButtonThemeData(
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                  ),
                ),
                child: new OutlineButton(
                  child: Text("退出登录"),
                  onPressed: (){
                    //退出登录
                    _logOut();
                  },
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.red,
                ),
              ),
            ) : new Container(),
          ],
        ),
      ),
    );
  }

  //native push
  _nativePushSubPage(UserCenterType idx) {
    methodChannel.invokeMethod("pushSubPage",idx.index);
  }

  //用户中心列表
  List<Widget> getUserCenterCountListData(){
    List<Widget> widgets = new List();
    for (var i = 0; i < listData.length; i++) {
      Widget widget = new GestureDetector(
          onTap: (){
            UserItemModel model = listData[i];
            _nativePushSubPage(model.itemType);
          },
          //  child:  new ListTile(
          //    onTap: changeItemColor,
          //  leading: Padding(
          //    padding: EdgeInsets.only(top: 15,bottom: 15,left: 10),
          //     child: Image.asset(
          //     imgArr[i],
          //     //color: Colors.blue,//color 会影响 图片颜色
          //     fit: BoxFit.contain,
          //     width: 20.0,
          //     height: 20.0,
          //    )
          //  ),
          //  title: Text(titles[i]),
          //  subtitle: Text(titles[i]),

          //不用listtitle 自己写一个
          child : new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              child: new Column(
                children: <Widget>[

                  new Row (
                    children: <Widget>[
                      Padding(
                        child: Image.asset(
                          listData[i].img,
                          //color: Colors.blue,//color 会影响 图片颜色
                          fit: BoxFit.contain,
                          width: 20.0,
                          height: 20.0,
                        ),
                        padding: EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 10),//EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                      Text(
                        listData[i].title,
                      ),
                    ],
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 20,right: 20),
                    child : new Divider(
                      height: 1,
                      color: Colors.blue[50],
                    ),
                  )
                ],
              )
          )
      );
      widgets.add(widget);

      // Widget widget = new GestureDetector(
      //   child: new ListItem(
      //   () =>  new Column(
      //           children: <Widget>[
      //             new Row (
      //               children: <Widget>[
      //                 Padding(
      //                   child: Image.asset(
      //                     imgArr[i],
      //                     //color: Colors.blue,//color 会影响 图片颜色
      //                     fit: BoxFit.contain,
      //                     width: 20.0,
      //                     height: 20.0,
      //                       ),
      //                     padding: EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 10),//EdgeInsets.fromLTRB(10, 10, 10, 10),
      //                     ),
      //                   Text(
      //                     titles[i],
      //                   ),
      //                 ],
      //             ),
      //             new Padding(
      //               padding: EdgeInsets.only(left: 20,right: 20),
      //               child : new Divider(
      //                     height: 0.5,
      //                     color: Colors.blue[50],
      //                 ),
      //             )
      //           ],
      //         ),
      //   ),
      // );
      // widgets.add(widget);
    }
    return widgets;
  }
  Widget getUserAccountWidget() => new UserAccountWidget();
}

// 用户信息状态

class UserAccountWidget extends StatefulWidget {
  @override
  _UserAccountWidgetState createState() => _UserAccountWidgetState();
}

class _UserAccountWidgetState extends State<UserAccountWidget> {

  String bigTitle = "";
  String subTitle = "";
  dynamic loginInfo;
  //利用native 去获取一些必要的信息
  dynamic _getLoginAccount () async {
    loginInfo = await _getLoginState();
    setState(() {
      bool islogin = loginInfo["isLogin"];
      if (islogin) {
        dynamic wxAccount = loginInfo["wxAccount"];
        dynamic phoneAccount = loginInfo["phoneAccount"];
        if (wxAccount != null) {
          bigTitle = wxAccount["nickName"];
          subTitle = "手机号未登录";
        }
        if (phoneAccount != null) {
          bigTitle = "讯飞翻译账号";
          subTitle = "+" + phoneAccount["countryNumber"] + phoneAccount["phone"];
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bigTitle = "登录";
    subTitle = "登录后可保留翻译记录";
    _getLoginAccount();

    NotificationStreamManager.instance.addObserverToStream(this.widget, "loginSuccess",
        onListenData: (data){
          _getLoginAccount();
        });
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  void duandian ()
  {
    bool islogin = loginInfo["isLogin"];
    if (!islogin) {
      methodChannel.invokeMethod("pushToLogin");
    } else {
      methodChannel.invokeMethod("pushToAccountInfo");
    }
  }
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed("about");
      },
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 20,bottom: 0,left: 20,right: 20),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "$bigTitle",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                )
            ),
            Text(
                "$subTitle",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.left
            ),
            new Padding(
                padding: EdgeInsets.only(bottom: 0,top: 20),
                child: new Divider(
                  height: 0.5,
                  color: Colors.blue[50],
                )
            ),
          ],
        ),
      ),
    );
  }
}
//import 'showshocks.dart'


// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(new MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final appName = 'Custom Themes';

//     return new MaterialApp(
//       title: appName,
//       theme: new ThemeData(
//         brightness: Brightness.light,
//         primaryColor: Colors.grey[100],
//         accentColor: Colors.cyan[600],
//       ),
//       home: new MyHomePage(
//         title: appName,
//       ),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   final String title;

//   MyHomePage({Key key, @required this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(title),
//       ),
//       // body: new Center(
//       //   child: new Container(
//       //     color: Theme.of(context).accentColor,
//       //     child: new Text(
//       //       'Text with a background color',
//       //       style: Theme.of(context).textTheme.title,
//       //     ),
//       //   ),
//       // ),
//       // floatingActionButton: new Theme(
//       //   data: Theme.of(context).copyWith(accentColor: Colors.yellow),
//       //   child: new FloatingActionButton(
//       //     onPressed: null,
//       //     child: new Icon(Icons.add),
//       //   ),
//       // ),
//     );
//   }
// }