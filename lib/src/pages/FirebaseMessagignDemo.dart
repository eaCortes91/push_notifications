import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:push_notifications/src/pages/look_messages.dart';

//import 'package:push_notifications/src/pages/look_messages.dart';
//import 'package:push_notifications/src/widgets/headers.dart';


class FirebaseMessagingDemo extends StatefulWidget {
  final String name;
  FirebaseMessagingDemo({Key key, @required this.name}) : super(key:key);
  final String title = 'Mensajería App';
  //final Destination destination;


  @override
  _FirebaseMessagingDemoState createState() => new _FirebaseMessagingDemoState();
}

class _FirebaseMessagingDemoState extends State<FirebaseMessagingDemo> {

  String _locationMessage = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;
  final databaseReference = Firestore.instance;
  bool isWitched = false;
  String cadena = '';
  
  //int _currentIndex = 0;

  LocationData currentLocation;
  Location location;

  _getToken(){
    //final deviceToken;
    _firebaseMessaging.getToken().then((deviceToken){
      print("device Token: $deviceToken");
      _getData(deviceToken);   
      //updateData(deviceToken, cLoc);
    });   
    
  }

  _configureFirebaseListeners(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        print('onMessage: $message');      
        _setMessage(message);
        showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Tomar viaje'),
                            onPressed: () => Navigator.push(context, 
                              MaterialPageRoute(
                                builder:(context) => LookMessage(id: message['data']['message'],))),
                        ),
                        FlatButton(
                            child: Text('Declinar'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );
      },
      onLaunch: (Map<String, dynamic> message) async{
        print('onLaunch: $message');
        _setMessage(message);
        Navigator.push(context, 
            MaterialPageRoute(
              builder:(context) =>LookMessage(id: message['data']['message'],)));
        
      },
      onResume: (Map<String, dynamic> message) async{
        print('onResume: $message');
        _setMessage(message);
        Navigator.push(context, 
            MaterialPageRoute(
              builder:(context) => LookMessage(id: message['data']['message'],)));
      },
    );
  }

  _setMessage(Map<String, dynamic>message){
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['tiitle'];
    final String body = notification['body'];
    final String mMessage = data['message'];
    setState((){
      Message m = Message(title, body, mMessage);
      //Navigator.push(context, LookMessage(m));
      _messages.add(m);

    });
    
  }

_getData(deviceToken) async{
  
  List usuarios = [];
    await databaseReference
      .collection("Users")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
        
          return usuarios.add(f.data['email']);    
          
        }
        );
        print(usuarios);
        String a  = deviceToken.toString();
        if(usuarios.contains(widget.name)){
          print('true');
          updateUserToken(widget.name, a);
        }else{
          createRecord(a);
        }
      });
  } 



  @override
  void initState() { 
    super.initState();
    //_getbool(widget.name);
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc){
      //return currentLocation = cLoc;
      //print(cLoc.latitude);
      double lat = cLoc.latitude;
      double long = cLoc.longitude;
      updateData(lat, long);
      
    });
    _getToken();
    _messages = List<Message>();
    _configureFirebaseListeners();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      
    ]);
   // _getCurrentLocation();
    
  }

  Future<dynamic> checkBoolStatus(name) async {
    DocumentSnapshot snapshot =
        await databaseReference.collection('Users').document(name).get();
    return snapshot.data['online'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
       body:CustomPaint(
         painter: _HeaderCurvoPainter(),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          //HeaderDiagonal(),
          Padding(padding: EdgeInsets.all(10)),
          Image.asset('assets/motonetapng.png',
                  scale: 4,),
          
          Center(child: 
            Text('Bienvenido ' + widget.name + '!',
              style: TextStyle(
                fontSize: 24.0,
                color: Color(0xffc75090)
              ),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder(
            future: checkBoolStatus(widget.name),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                bool result = snapshot.data;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Desconectado',
                    style: TextStyle(fontSize: 14, color:Colors.blueAccent),),
                    Padding(padding: EdgeInsets.all(3)),
                    Switch(value: result, onChanged: (bool newVal) {
                      setState(() => result = newVal);
                      updateDataAvailability(newVal);
                      //_getbool(widget.name);
                    }),
                    Padding(padding: EdgeInsets.all(8)),
                    Text('Conectado',
                    style: TextStyle(fontSize: 14, color:Colors.blueAccent),)
                  ],);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          ),
           Text('Mueve para estar Desconectado/Conectado',
              style: TextStyle(
              fontSize: 16.0,
              color: Color(0xff150046)
              ),
            ),
          Padding(padding: EdgeInsets.all(70))
        ],
       
      ),
       ),

    );
  }
  
  void getDocumentFirestore(){
    DocumentReference documentReference = Firestore.instance
    .collection('Messages').document('EtvsaqoqrzgWlWqiSyi3');

    documentReference.get().then((datasnapshot){
      if(datasnapshot.exists){
        print(datasnapshot.data['message'].toString());
      }else{
        print("error");
      }
    });
  }  

  void createRecord(b) async {
    //_getCurrentLocation();
    //GeoPoint(position, longitude)
    await databaseReference.collection("Users")
      .document(widget.name)
      .setData({
        'device_token': b,
        'user_name': widget.name,
        'online': true,
        'real_time_location': _locationMessage,
        'email': widget.name,
        'rol':'repartidor',
        'direccion': "",
        'telefono': '',

      });
      
  }

  void updateData(b,d) {
    //double lat = b[];
    try {
      databaseReference
        .collection('Users')
        .document(widget.name)
        .updateData({'real_time_location': GeoPoint(b, d)});
    } catch (e) {
      print(e.toString());
    }
  }

  void updateDataAvailability(b) {
    try {
      databaseReference
        .collection('Users')
        .document(widget.name)
        .updateData({'online': b});
    } catch (e) {
      print(e.toString());
    }
  }

  void updateUserToken(user, tokenUser) {
    
    databaseReference
      .collection('Users')
      .document(user)
      .updateData({'device_token': tokenUser})
      .then((result){
        print('Update Correct');
      }).catchError((onError){
        print('Eroor');
      }); 
  }

}

class Message{
  String title;
  String body;
  String message;
  Message(title, body, message){
    this.title = title;
    this.body = body;
    this.message = message;
  }
  
}

class _HeaderCurvoPainter extends CustomPainter{
 
  @override
  void paint(Canvas canvas, Size size){

    final lapiz = Paint();

    //Propiedades de mi lapiz
    lapiz.color = Color(0xff90395d);
    lapiz.style = PaintingStyle.fill;
    lapiz.strokeWidth = 5;

    final path = new Path();

    //Dibujo en el path y con el lapiz
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.30, size.height, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    


    canvas.drawPath(path, lapiz);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}

