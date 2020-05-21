
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/services.dart';

//import 'package:push_notifications/src/widgets/headers.dart';

class HomePage extends StatefulWidget {
  //const name({Key key}) : super(key: key);
  final String name;
  HomePage({Key key, @required this.name}) : super(key:key);
   @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage>{

  final databaseReference = Firestore.instance;
 //String _locationMessage = "";
  //var i = 0;
  List usuarios =[];
  GeoPoint position;
  Location location;
  LocationData currentLocation;
  String _locationMessage = "";
  String number = "";
  String adress = "";
  String initialDirection = "";
  String messageID = '';
   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
 //String token ='cH_Pp7Wj3Ns:APA91bEpGf8FpUHAloXXd-SRKeYayLINX5ECdshaXRQq6tUOuMi6HkE9l81cwVHqKeOsPNtxV2i2U9eMLLQuZI5MNbhfGPLvzgg-HGY_OLFYwnqEx4s-yIojItkEzM9JlAbiSP2pcgfI';
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  Timer _timer;
  Timer _timer2;
  String idMessage = '';

  //List userObject = [];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      
    ]);
    //_getCurrentLocation();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: _HeaderCurvoPainter(),
        child: Center(
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/motonetapng.png',
                  scale: 5,), 
                Padding(padding: EdgeInsets.all(10)),
                Text('Direccion a donde envías.'),
                TextField(
                  controller: myController1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xfff7f7f7),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey),
                    )
                  ),
                ),
                Padding(padding: const EdgeInsets.all(10)),
                Text('Mensaje extra.'),
                TextField(
                  controller: myController2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xfff7f7f7),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey),
                    )
                  ),
                ),
                Padding(padding: const EdgeInsets.all(10)),
                RaisedButton(  
                  onPressed: () {
        
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context){
                        Future.delayed(Duration(seconds: 25), () {
                          Navigator.of(context).pop(true);
                          _isTrackerTake(messageID);
                        });
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ), 
                          child: Container(
                            height:200,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder(
                                    stream: Firestore.instance
                                      .collection("Tracking")
                                      .document("vacio")
                                      .snapshots(),
                                    builder: (context, f) {
                                      if (!f.hasData ) {    
                                         return Center(
                                          child:Column(
                                            children: <Widget>[
                                              
                                              Text('Alguien a tomado tu solicitud.'),
                                              Text('Pronto llegara un repartidor.'),
                                              //Padding(padding: EdgeInsets.all(10) ),
                                              //CircularProgressIndicator(),
                                              FlatButton(
                                                color: Color(0xff90395d),
                                                textColor: Colors.white,
                                                onPressed: (){ Navigator.pop(context);}, 
                                                child: Text('Ok!'))
                                            ],
                                          )
                                        );
                                      }else{
                                        return Center(
                                          child:Column(
                                            children: <Widget>[
                                              Text('Procesando...'),
                                              Padding(padding: EdgeInsets.all(10) ),
                                              CircularProgressIndicator(),
                                              Padding(padding: EdgeInsets.all(10)),
                                              FlatButton(
                                                color: Color(0xff90395d),
                                                textColor: Colors.white,
                                                onPressed: (){ 
                                                  Navigator.pop(context);
                                                  _cancelarRepartidor(messageID);
                                                  print('messageID cancelado: ${messageID}');
                                                }, 
                                                child: Text('Cancelar')
                                              ),
                                              
                                            ],
                                          )
                                        );
                                        //Text('No se encuentran los datos, verifica tu conneccion a internet');
                                      }
                                    },
                                  ),              
                                ],
                              ),
                            ),
                          ),          
                        );
                      }
                    );           
                    //print('${myController1.text} ${myController2.text}' );
                   _getTokens();
                   _timer = new Timer(const Duration(milliseconds: 400), () {
                    setState(() {
                      _getData();
                      
                    });
                  });
                   
                  // _getData();
                
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration:const BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                        Color(0xFF914aaa),                      
                        Color(0xFFca5198),
                      ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text('Solicitar envío',
                    style: TextStyle(
                      fontSize:20,
                      color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ),
      )
    );
  }

  _cancelarRepartidor(a){
    
    try {
      databaseReference
          .collection('Messages')
          .document(a)
          .updateData({'activo': 'desactivado'});
    } catch (e) {
      print(e.toString());
    }
  

  }

  _isTrackerTake(idMessage) async{

    print('este es el id: $idMessage');
    DocumentReference documentReference =
      Firestore.instance.collection("Tracking").document(idMessage);

    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        showDialog(
          context: this.context,
          child:new Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child:Text('Alguien ya tomó tu pedido',style:TextStyle(fontSize: 18), textAlign: TextAlign.center,))
                  ],
                ),
              )
            ),
          )
        );            
      }else{
        showDialog(
          context: this.context,
          child:new Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child:Text('No hay repartidor disponible, intenta de nuevo.',style:TextStyle(fontSize: 18), textAlign: TextAlign.center,))
                  ],
                ),
              )
            ),
          )
        );
      }
    });
   
  }

  _createRecord(mensaje, direccionFinal) {
    
    var fecha = new DateTime.now();
    //String numeroTelefonico = _getPhoneNumber();
    //String direccionDelLocal = _getAddress();
    DocumentReference ref = Firestore.instance.collection('Messages').document();   

      ref.setData({
        'id': ref.documentID,
        'user': widget.name,
        'message': mensaje,
        'fecha': fecha,
        'direccion_inicial': adress,
        'direccion_final': direccionFinal,
        'numero': number,
        'activo':'activo',
      });
      print(ref.documentID);
      idMessage = ref.documentID;
    return ref.documentID;
  } 

  _getTokens(){
    //List token = [];
    databaseReference
      .collection("DeviceTokens")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          //print(f.data['device_token']);
          deleteData(f.data['device_token']);
          //token.add(f.data['device_token']);
          //deleteData();
          //print(token.length);
        }
        );
      });
  }

  _getData(){
  
    _getUsersNear();
    int i = 0;
    databaseReference
      .collection("Users")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          //print('${f.data['device_token']}');
          //List usuarios = [];
          //print('Estos son los usuarios: ');     
          if(f.data['online'] == true && f.data['rol'] == 'repartidor'){
            //usuarios.add(f.data['real_time_location']);  
            //GeoPoint geopoint = usuarios[i];
            GeoPoint geopoint = f.data['real_time_location'];
            double lat2 = geopoint.latitude;
            double long2 = geopoint.longitude;
            double lat1 = currentLocation.latitude;
            double long1 = currentLocation.longitude;
            double calculateDistance(la1, lo1, la2, lo2){
              var p= 0.017453292519943295;
              var c= cos;
              var a = 0.5 - c((la2 - la1) * p)/2 +
                    c(lat1 * p) * c(lat2 * p) *
                    (1 - c((lo2 - lo1) * p))/2;
            return 12742 * asin(sqrt(a));
            }
            double harvesine = calculateDistance(lat1, long1, lat2, long2);
            if(harvesine <= 10.0 ){
              print(f.data['email']);
              print(harvesine);
              var userNear = f.data['device_token'];
            
              updateTokens(userNear);
              //var a =_getPhoneNumber();
              //createRecord(myController2.text, myController1.text, number , adress);
            }
            else{
              print("");
            }
          }
          else{
            print('offline');
          }
          
          i = i +1;
          return i;  
        }
        );
      });
          
          messageID =_createRecord(myController2.text, myController1.text);
  } 

  void updateTokens(a) {
    try {
      databaseReference
          .collection('DeviceTokens')
          .document(a)
          .setData({'device_token': a});
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

  void deleteData(data){ 
  try { 
    databaseReference
         .collection('DeviceTokens') 
        .document(data) 
        .delete().then((_){
          print(data);
        }); 
  } catch(e) { 
    print(e.toString ()); 
  } 
}

 void _getUsersNear(){

  location = new Location();
  location.onLocationChanged.listen((LocationData cLoc){
      return currentLocation = cLoc;
      
    });
}


  _getUserData(deviceToken) async{
  
  List usuarios = [];
    await databaseReference
      .collection("Users")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          //print('${f.data['device_token']}');
          //List usuarios = [];
          return usuarios.add(f.data['email']);    
          //print(usuarios);
        }
        );
        print(usuarios);
        String a  = deviceToken.toString();
        if(usuarios.contains(widget.name)){
          _getPhoneNumber();
          _getAddress();
          updateUserToken(widget.name, a);
        }else{
          createUser(a);
        }
      });
    //print(deviceToken + 'aaaaaa');
    //return deviceToken;
  } 

  _getPhoneNumber() async {

     final documents = await databaseReference.collection('Users').where("email", isEqualTo: widget.name).getDocuments();
     final userObject = documents.documents.first.data;
     number = userObject['telefono'];
     return number;
   
  }
  _getAddress() async {

     final documents = await databaseReference.collection('Users').where("email", isEqualTo: widget.name).getDocuments();
     final userObject = documents.documents.first.data;
     adress = userObject['direccion'];
     return adress;
   
 }

  void createUser(b) async {
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
  _getToken(){
    //final deviceToken;
    _firebaseMessaging.getToken().then((deviceToken){
      print("device Token: $deviceToken");
      _getUserData(deviceToken);   
      //updateData(deviceToken, cLoc);
    });   
    
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