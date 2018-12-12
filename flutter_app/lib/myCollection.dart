import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model.dart';


class MyCollectionPage extends StatelessWidget {
    
    @override
    Widget build(BuildContext context) {
       return new Scaffold(
         backgroundColor: Colors.blue[50],
         body: CollectionListView(),
       );
    }
}

class CollectionListView extends StatefulWidget { 
  
   @override
   _CollectionListViewState createState() => _CollectionListViewState();
   
}

class _CollectionListViewState extends State<CollectionListView> {
  
  List listData = new List();
  var isNoData;
  var isNetWorkBad;
  var CurPage = 1;

  var methodChannel = const MethodChannel("flutterModule_collection_Channel");
  ScrollController _controller = new ScrollController();

  EventChannel eventChannel = const EventChannel("Collected_flutter");
  
  _CollectionListViewState (){
     _controller.addListener((){
       var maxScrollScale = _controller.position.maxScrollExtent;//最大的 滚动范围
       var currentScrollPosition = _controller.position.pixels; 
        if (maxScrollScale == currentScrollPosition) {
           //load more
           MyCollectionModel model = listData.last;
           print(model.serverUid);
           _loadCollectionData(model.serverUid);
        }
     });
  }

  @override
  void initState() { 
      super.initState();
      _loadCollectionData("0");
      eventChannel.receiveBroadcastStream().listen(dismissLongPressView);
    }

  void dismissLongPressView (Object data){ 
    print(data.toString());
      setState(() {
        if (data.toString() == "true") {
          
        } 
      });
  }

    //load list data
    _loadCollectionData (String lastServerUid) async { 
       dynamic result = await methodChannel.invokeMethod("getCollectionList",lastServerUid);
       print("result:" + result.toString());
       if (result != null) {  
          setState(() {
            List results = result;
            for (int i = 0; i< results.length; i++) {
              Map collectionRecord = results[i];
              
              MyCollectionModel model = new MyCollectionModel();
              model.sourceText = collectionRecord["sourceText"];
              model.transText = collectionRecord["transText"];
              model.sourceAudioUrl = collectionRecord["sourceAudioUrl"];
              model.serverUid = collectionRecord["serverUid"];
              listData.add(model);
            } 
          }); 
       }
    } 

  Widget rendRow(i) { 
    MyCollectionModel record = listData[i]; 
    CollectionItem recordItem = new CollectionItem(record,i);
    recordItem.onLongPressRecord = (MyCollectionModel record,int idx){
        //长按记录 
        methodChannel.invokeMethod("OnLongPressRecord",idx);
    };
    return recordItem;
  }

  @override
   Widget build(BuildContext context) {
     if (listData.length == 0) {
       return new Center(
        // CircularProgressIndicator是一个圆形的Loading进R度条
        child: new CircularProgressIndicator(),
      );
     } else { 
       //return new RefreshIndicator( 
         //child: 
        return new ListView.builder(
           physics: new AlwaysScrollableScrollPhysics(),
              itemCount: listData.length,
              itemBuilder: (context, i) => rendRow(i),
              controller: _controller,
              );
          //onRefresh: _pullMoreRecord,
      //  );
     }
   }
}

typedef collectionOnLongPress = void Function(MyCollectionModel model,int idx);

class CollectionItem extends StatefulWidget { 
  MyCollectionModel record;
  int     index;
  collectionOnLongPress onLongPressRecord ;
  int playState = 1;//1 normal 2 playing 3 error

  CollectionItem(record,idx) {
    this.record = record;
    this.index = idx;
  }
  @override
  _CollectionItemState createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
   
   Color bgColor = Colors.white; 
   bool isLongPress = false;

   Widget build(BuildContext context) {
     var sourceRow = new Padding( 
        padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20), 
        child: Text(this.widget.record.sourceText,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Color.fromRGBO(132, 153, 181, 1),//fromARGB(1, 132 , 153, 181),
          height: 1.5, //行高 a multiple of the font size
        ),
      ),
     );
     
     var divider = new Padding(
       padding: EdgeInsets.only(left: 20,right: 20),
       child: new Divider(
         height: 1,
         color: Colors.blue[50],
       ),
     );

     var tranRow = new Padding(
       padding: EdgeInsets.only(top: 10,bottom: 10,left: 20, right: 20),
       child: Text(this.widget.record.transText,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.black,//fromARGB(1, 53, 53, 53)
          height: 1.5,
        ),
       ),                     
     );

      var playing1 =  new IconButton( 
          icon: Image.asset("assets/play1-3.png"),
          iconSize: 25.0,
          onPressed: (){
            //点击
            print("click playing");
          },
        );

        return new Padding(
          padding: EdgeInsets.only(top: 10),
          child: new GestureDetector(
            onLongPress: (){ 
               setState(() {
                isLongPress = !isLongPress;
                  if (isLongPress) {
                    bgColor = Color.fromRGBO(208, 225, 242, 1);//fromARGB(1, 208 , 225 , 242);
                    if (this.widget.onLongPressRecord != null) {
                      this.widget.onLongPressRecord(this.widget.record,this.widget.index);
                    }
                  } else {
                    bgColor = Colors.white;
                  }  
              }); 
            },
            child: new Container(
                color: bgColor, 
                child: new Container( 
                  child: new Column( 

                    children: <Widget>[
                      new Row( 
                        mainAxisSize: MainAxisSize.max, 
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: sourceRow,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: playing1,
                          )
                        ],
                      ),
                      divider,
                      new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Expanded(
                            child: tranRow,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: playing1,
                          )
                        ],
                      ), 
                    ],
                  ),
                ),
           ), 
        ) 
      );
   }
}









