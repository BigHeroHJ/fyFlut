import "package:flutter/material.dart";

//Hero page
class HeroPage extends StatefulWidget {

  @override
  HeroState createState() => new HeroState();
}

class HeroState extends State<HeroPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: Text("Hero Image Animation"),
      ),
    );
  }
}
