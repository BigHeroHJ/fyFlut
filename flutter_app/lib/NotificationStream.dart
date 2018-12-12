
import 'dart:async'; 
import 'package:flutter/material.dart';
  
typedef  observerCallBackOnData  = Function (dynamic data);
typedef  observerCallBackOnCancel  = Function ();
 
 // in same flutterviewcontroller

class NotificationStreamManager {
  static final NotificationStreamManager notificationStream = new NotificationStreamManager._internal();

  //static NotificationStreamManager center() => notificationStream;
  static NotificationStreamManager get instance => notificationStream;
  // 维护一个map
     Map<String,StreamController> centerMap = new Map();
     List <StreamObserver> subScripTions = new List(); 
     int age = 100; 
  factory NotificationStreamManager() {
    return notificationStream;
  } 
  
  NotificationStreamManager._internal();
  
  registerStream(String key) {  
    StreamController newStreamNotfi = new StreamController.broadcast(sync: false);
    if (centerMap.containsKey(key)) { 
       centerMap.update(key, (newStreamNotfi) => newStreamNotfi, );  
    } else {
       centerMap.putIfAbsent(key, ()=>newStreamNotfi);
    } 
  }

  void addObserverToStream(StatefulWidget observer,String key,{void onListenData(data),void onCancel()}){
    assert(key.length != 0,"key lenght is null or \"\"");
    assert(centerMap.containsKey(key),"addObservStream key is not reigitser before observe");
    StreamController streamController = this.centerMap[key];
    StreamSubscription subscription = streamController.stream.listen((data){
      
    },);
    subscription.onData((data){
      onListenData(data);
    });

    subscription.onDone((){
      onCancel();
    });

    print("suc");
    subScripTions.add(StreamObserver(obsever: observer,key: key,streamSubscripter: subscription));
  }

  void postStreamByKey(String key,dynamic events) {
    print(key);
    print(this.centerMap.toString());
    assert(key.length != 0,"key lenght is null or \"\"");
    assert(this.centerMap.containsKey(key),"addObservStream key is not reigitser before observe");
    StreamController streamController = this.centerMap[key];
    streamController.add(events);
  }

// TODO：补充线程安全
  void cancelSubscription(String key , StatefulWidget observerWillRemove) {
    for(int i = 0;i < subScripTions.length;i++) {
      StreamObserver observer = subScripTions[i];
      if (observer.key == key && observer.streamSubscripter.hashCode == observerWillRemove.hashCode) {
        StreamSubscription streamSubscription = observer.streamSubscripter;
        streamSubscription.cancel();
        subScripTions.removeAt(i);
        return;
      }
    }
  }

//暂不用 没考虑好
  void cancelStreamControl(key) {
    assert(key.length != 0,"key lenght is null or \"\"");
    StreamController streamController = centerMap[key];
    streamController.onCancel();
    streamController.close(); 
  }
}

 class StreamObserver{
   final StatefulWidget obsever;
   final String key;
   final StreamSubscription streamSubscripter;

    const StreamObserver({
       this.obsever,
       this.key,
       this.streamSubscripter
    }) : assert (obsever != null),assert(key != null),assert(streamSubscripter != null);

    // const StreamObserver(this.obsever,this.key,this.streamSubscripter) : assert(false);
    
    // StreamObserver(StatefulWidget obsever,String key,StreamSubscription streamSubscripter) {
    //   this.obsever = obsever;
    //   this.key = key;
    //   this.streamSubscripter = streamSubscripter;
    // }
  } 