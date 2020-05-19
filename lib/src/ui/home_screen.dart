import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:push_notifications/src/bloc/authentication_bloc/bloc.dart';
import 'package:push_notifications/src/pages/FirebaseMessagignDemo.dart';
import 'package:push_notifications/src/pages/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:push_notifications/src/widgets/headers.dart';




class HomeScreen extends StatefulWidget {

  final String name;
  HomeScreen({Key key, @required this.name}) : super(key: key);
  

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessagingg = FirebaseMessaging();

  final bool isDelivery = false;

  String _locationMessage = "";
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseReference = Firestore.instance;
  

  _getToken(){
    _firebaseMessagingg.getToken().then((deviceToken){
      //print("device Token: $deviceToken");
      _getData(deviceToken);   
    });
  }

  @override
  void initState() { 
    super.initState();
    _getToken();  
    _getUser();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      
    ]);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          )
        ],
      ),*/
      body:CustomPaint(
        painter: _HeaderCurvoPainter(),
        child:  Center(
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                //Padding(padding: EdgeInsets.all(20)),
                Text('Bienvenido ${widget.name}! estamos procesando tu solicitud, reinicia la app.',
                  style: TextStyle(
                    fontSize:22,
                    color: Color(0xff121a3f)),
                  textAlign:TextAlign.center,
                ),   
                Padding(padding: EdgeInsets.all(25)),    
                Image.asset('assets/motonetapng.png',
                  scale: 5,),        
               // Padding(padding: EdgeInsets.all(0))
              ],
            ),
          )),
      )
    );
  }

Future _getUser() async{
  await databaseReference
      .collection("Users")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {

          if(f.data['rol'] == 'repartidor' && f.data['email'] == widget.name){
            print('Mi name :${widget.name}');
            Navigator.push(context, 
            MaterialPageRoute(
              builder:(context) => FirebaseMessagingDemo(name:widget.name )));
          }
          if(f.data['rol'] == 'tienda' && f.data['email'] == widget.name){
            print('Mi name :${widget.name}');
            Navigator.push(context, 
            MaterialPageRoute(
              builder:(context) => HomePage(name:widget.name )));
          }
          else{
            print('no definido');
          }
          //print('${f.data['device_token']}');
          //List usuarios = [];
          //return usuarios.add(f.data['email']);    
          //print(usuarios);
        }
        );
        
      });
 
} 

  _getData(deviceToken) async{
  
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
          print('true');
        }else{
          createRecord(a);
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
        'rol_definido': false,

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
