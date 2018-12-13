import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_app/HeroAnimatPage.dart';

import 'dart:math' as math;
import 'package:flutter/scheduler.dart' show timeDilation;

class TextTranslateWidget extends StatefulWidget {
  @override
  _TextTranslateWidgetState createState() => _TextTranslateWidgetState();
}

class _TextTranslateWidgetState extends State<TextTranslateWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          RadialExpansionDemo(),
          LogApp1(),
          HeroAnimation(),
          RaisedButton(
            onPressed: () {
//              Navigator.push(context, new MaterialPageRoute(
//                builder: (BuildContext context) {
//                  return HeroPage();
//                },
//              ));

              Navigator.push(
                context,
                new PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return HeroPage();
                    },
                    transitionDuration: Duration(seconds: 10),
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
//                      return  new FadeTransition(opacity: new Tween(begin: 0.0 ,end: 1.0).animate(animation);

//                      return new SlideTransition(
//                        position: new Tween<Offset>(
//                          begin: const Offset(1.0, 0.0),
//                          end: const Offset(0.0, 0.0),
//                        ).animate(animation),
//                        child: child, // child is the value returned by pageBuilder
//                      );

                      return new FadeTransition(
                        opacity:
                            new Tween(begin: 0.0, end: 1.0).animate(animation),
                        child: SlideTransition(
                          position: new Tween<Offset>(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation),
                          child: child,
                        ),
                      );
                    }),
              );
            },
            child: Text("Hero Aniation Example"),
          ),
        ],
      ),
    );
//    return MaterialApp(
//      routes:{
//        "HeroSecond" : (BuildContext context) =>  new HeroPage(),
//      },
//      home: new Column(
//        children: <Widget>[
//          LogApp1(),
//          RaisedButton(onPressed: (){
//            Navigator.pushNamed(context, "HeroSecond");
//          },
//          child: Text("Hero Aniation Example"),),
//        ],
//      ),
//    );
  }
}

// **********  radial_hero_animation  ***********//
// 封装一个photo
class Photo extends StatelessWidget {
  Photo({this.photo, this.color, this.onTap});
  final String photo;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: InkWell(
        onTap: onTap,
        child:
            LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
          return Image.asset(
            photo,
            fit: BoxFit.contain,
          );
        }),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({Key key, this.maxRadius, this.child})
      : clipRectSize = 2.0 * (maxRadius / math.sqrt2),
        super(key: key);
  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,
          ), //clipper is null 就会按原本的size 来 如果传入了cliper 就决定使用哪个cliper
        ),
      ),
    );
  }
}

class RadialExpansionDemo extends StatelessWidget {
  static const double KMinRadius = 32.0;
  static const double kMaxRadius = 128.0;

  static const opacityCurve =
      const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  static RectTween _createRectTween(Rect begin, Rect end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }

  //hero 点进来的页面
  static Widget _buildPage(
      BuildContext context, String imageName, String descirpiton) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Center(
        child: Card(
          elevation: 8.0, //阴影 和 appbar 一样
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: kMaxRadius * 2.0,
                height: kMaxRadius * 2.0,
                child: Hero(
                    tag: imageName,
                    child: Photo(
                      photo: imageName,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )),
              ),
              Text(
                descirpiton,
                textScaleFactor: 3.0,
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //这个是包含了photo 的hero
  Widget _buildHero(
      BuildContext context, String imageName, String description) {
    return Container(
      width: KMinRadius * 2.0,
      height: KMinRadius * 2.0,
      child: Hero(
        tag: imageName,
        createRectTween: _createRectTween,
        child: RadialExpansion(
          maxRadius: kMaxRadius,
          child: Photo(
            photo: imageName,
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(pageBuilder:
                  (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget child) {
                      return Opacity(
                        opacity: opacityCurve.transform(animation.value),
                        child: _buildPage(context, imageName, description),
                      );
                    });
              }));
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      alignment: FractionalOffset.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHero(context, 'assets/chair-alpha.png', 'Chair'),
          _buildHero(context, 'assets/binoculars-alpha.png', 'Binoculars'),
          _buildHero(context, 'assets/beachball-alpha.png', 'Beach ball'),
        ],
      ),
    );
  }
}

// ********** Hero animation  ***//
class PhotoHero extends StatelessWidget {
  final String photo;
  final double width;
  final VoidCallback onTap;

  const PhotoHero({Key key, this.photo, this.width, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width,
      child: new Hero(
          tag: this.photo,
          child: new Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: new FlutterLogo(),
            ),
          )),
    );
  }
}

class HeroAnimation extends StatelessWidget {
  Widget build(BuildContext context) {
    timeDilation = 1.0; // 1.0 means normal animation speed.

    return Container(
      child: Center(
        child: PhotoHero(
          photo: 'images/flippers-alpha.png',
          width: 300.0,
          onTap: () {
            Navigator.push(context, new PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Scaffold(
                    appBar: AppBar(),
                    body: Container(
                      color: Colors.lightBlueAccent,
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.topLeft,
                      child: PhotoHero(
                        photo: 'images/flippers-alpha.png',
                        width: 100.0,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ));
              },
            ));
            //transitionDuration: Duration(seconds: 5)
            //动画放慢点 能清除的看到 hero widget 的移动过程
          },
        ),
      ),
    );
  }
}
//***** 多个动画同时跑 基于animatedWidget

class LogApp1 extends StatefulWidget {
  LogAppState1 createState() => LogAppState1();
}

class LogAppState1 extends State<LogApp1> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 10));
    final curveAnimation = new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut);
    _animation = new Tween(
      begin: 0.0,
      end: 200.0,
    ).animate(curveAnimation);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new MultiAnimationWidget(
      animation: _animationController,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class MultiAnimationWidget extends AnimatedWidget {
  static final _sizeTween = new Tween(begin: 0.0, end: 300.0);
  static final _alpheTween = new Tween(begin: 0.1, end: 1.0);

  MultiAnimationWidget({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new FadeTransition(
        opacity: _alpheTween.animate(listenable),
        child: new Container(
          child: new FlutterLogo(),
          width: _sizeTween.evaluate(listenable),
          height: _sizeTween.evaluate(listenable),
        ),
      ),
    );
//    return new Center(
//      child: new Opacity(
//          opacity: _alphTween.animate(listenable).value,//animate内部也是是使用evaluate(listenable)作为get value 值
//        child: new Container(
//          child: new FlutterLogo(),
//          width: _sizeTween.evaluate(listenable),
//          height: _sizeTween.evaluate(listenable),
//        ),
//      ),//或者直接 alphTween.evalute(listenable)
//
//    );
  }
}

// ****** 使用AnimatedBuilder 类 基于AnimatedWidget 是将子widget 的动画部分抽离出来 返回

class LogApp extends StatefulWidget {
  LogAppState createState() => LogAppState();
}

class LogAppState extends State<LogApp> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 10));
    final curveAnimation = new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut);
    _animation = new Tween(
      begin: 0.0,
      end: 200.0,
    ).animate(curveAnimation);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new GrowTransition(
      child: new LogPage(),
      animation: _animation,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class LogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new FlutterLogo();
  }
}

class GrowTransition extends StatelessWidget {
  //一个无状态 lesswidget
  final Widget child;
  final Animation animation;
  //定义一个构造函数
  GrowTransition({this.child, this.animation});

  //返回build
  @override
  Widget build(BuildContext context) {
    return new Center(
      // 利用一个AnimatedBuilder 构造一个在child 上的过度动画
      child: new AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (BuildContext context, Widget child) {
//      builder 函数返回
            return new Container(
              height: animation.value,
              width: animation.value,
              child: child,
            );
          }),
    );
  }
}

//*****使用AnimatedWidget 类

class CusAnimatedWidget extends AnimatedWidget {
  CusAnimatedWidget({Animation listenable, Key key})
      : super(key: key, listenable: listenable); //listenable 是必传的，
  // 文档介绍一般是Animation 或者 另一个ChangeNotifier ，Animation是继承  Listenable，
  // 这个Animatedwidget 其实就是内部实现了addListener 方法
  // 不像之前的， 直接在state 中 写animated 代码，将动画代码抽离出来了，
  // 而外界只需要调用传入animation 作为listenable即可
  @override
  Widget build(BuildContext context) {
    final Animation animation = listenable;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}

// ****  给一个widget 添加动画效果
class TextPage extends StatefulWidget {
  @override
  TextPageState createState() => TextPageState();
}

class TextPageState extends State<TextPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    _animation = new Tween(begin: 0.0, end: 300.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        print("animation status:" + status.toString());
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    Widget squ = new Center(
      child: new Container(
        width: _animation.value,
        height: _animation.value,
        color: Colors.red,
        child: new FlutterLogo(),
      ),
    );

    return squ;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

//animation test
class AnimationWidgetTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//     AnimationController  _animationController = new AnimationController(
//         vsync: new TestStatefulWidget().createState(),
//         duration: Duration(seconds: 10)
//     );

    Tween(begin: 100, end: 200);
    //Tween 是无状态的stateless 他作用是提供一个映射，应用于当前的动画，
    //Animation  是有状态的 getStatus 和value
    // Tween 继承 Animatedable 类似Anination 但不会输出当前动画的value
    var con = new Container();
    AnimationController _animationC = new AnimationController(
      vsync: null,
      duration: Duration(seconds: 10),
    );
    Animation anima = Tween(begin: Colors.red, end: Colors.blue)
        .animate(_animationC)
          ..addListener(() {});

    return con;
  }
}

class TestStatefulWidget extends StatefulWidget {
  @override
  TestStatefulState createState() =>
      TestStatefulState(); //会回调多次 也可以多次创建state 根据不同情况创建不同state
}

class TestStatefulState extends State<TestStatefulWidget>
    with TickerProviderStateMixin /* SingleTickerProviderStateMixin*/ {
  AnimationController _animationController;
  AnimationController _animationController1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController1 =
        new AnimationController(vsync: this, duration: Duration(seconds: 10));

    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}

//class customCurve extends Curve{
//  return @override
//  double transform(double t) {
//    return math.sin(t * math.PI * 2);
//  }
//}
