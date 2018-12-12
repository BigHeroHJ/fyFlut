import 'package:flutter/material.dart';


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
    return TextPage();
  }
}

class TextPage extends StatefulWidget {

  @override
  TextPageState createState() => TextPageState();
}

class  TextPageState extends State<TextPage>  with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    _animation = new Tween(begin: 200,end: 300).animate(_animationController)..addListener((){
      setState((){

      });
    })..addStatusListener((status){
      print("animation status:" + status.toString());
    });

    _animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    Widget squ =  new SizedBox.fromSize(
     size: Size(200, 200),
          child:new Container(
            constraints: BoxConstraints.loose(Size(200, 200)),
        color: Colors.red,
        child: Icon(Icons.compare),
          ),
        );

    return squ;
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

   Tween(begin: 100,end: 200);
     //Tween 是无状态的stateless 他作用是提供一个映射，应用于当前的动画，
     //Animation  是有状态的 getStatus 和value
   // Tween 继承 Animatedable 类似Anination 但不会输出当前动画的value
   var con = new Container(

   );
   AnimationController _animationC = new AnimationController(vsync: null,duration: Duration(seconds: 10)

     ,);
    Animation anima = Tween(begin: Colors.red,end: Colors.blue).animate(_animationC)
      ..addListener((){

    });

     return con;
  }
}


class TestStatefulWidget extends StatefulWidget {
  @override
  TestStatefulState createState() => TestStatefulState();//会回调多次 也可以多次创建state 根据不同情况创建不同state
}


class TestStatefulState extends State<TestStatefulWidget>  with TickerProviderStateMixin/* SingleTickerProviderStateMixin*/{

  AnimationController _animationController;
  AnimationController _animationController1;

 @override
 void initState() {
    // TODO: implement initState
    super.initState();
    _animationController1 = new AnimationController(
        vsync: this,
        duration: Duration(seconds: 10)
    );

     _animationController = new AnimationController(
        vsync: this,
        duration: Duration(seconds: 10)
    );
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


