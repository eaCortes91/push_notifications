/*import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token){

      print('========= FCM Token =========');
      print(token);

      //ezalGdMQJmA:APA91bGLUsWAC3im9pj0eglDbbjYIzsfTBdhfy-s2DxP5xahKjLG1MF_5n1lQ10QG6FsQYhrPKhgH_ZTEbpX9ms5KDk_G6rJ0l5VI43RKcl6lv51Q-ow-3fDsX4UK1kjcpMVDgEjZxak
    
    });

    _firebaseMessaging.configure(

      onMessage: (info){
        print('====== On Message ========');
        print(info);

        String argumento = 'no-data';
        if(Platform.isAndroid){
          argumento = info['data']['comida']?? 'no-data';
        }

        _mensajesStreamController.sink.add(argumento);
      },
      onLaunch: (info){
        print('====== on Launch =========');
        print(info);
        
        final noti = info['data']['comida'];
        _mensajesStreamController.sink.add(noti);

      },
      onResume: (info){
        print('====== On Resume =========');
        print(info);
        
        final noti = info['data']['comida'];
        _mensajesStreamController.sink.add(noti);

      }
    );

  }

  dispose(){
    _mensajesStreamController?.close();
  }

}*/