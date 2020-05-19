import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class DeliveryTrack extends StatefulWidget {
  final String id;
  DeliveryTrack({Key key, @required this.id}) : super(key:key);

  @override
  _DeliveryTrackState createState() => _DeliveryTrackState();
}

class _DeliveryTrackState extends State<DeliveryTrack> {

  final databaseReference = Firestore.instance;
  //String _locationMessage = "";
  LocationData currentLocation;
  Location location;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getbool(widget.name);
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc){
      //return currentLocation = cLoc;
      //print(cLoc.latitude);
      double lat = cLoc.latitude;
      double long = cLoc.longitude;
      _trackingDevice(lat, long);
      
    });
    super.initState();
    //_borrarMessage(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: _HeaderCurvoPainter(),
        child: Center(
        child:Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Cuando realices la entrega no olvides finalizar el viaje.',
              textAlign: TextAlign.center,
              style: TextStyle(color:Color(0xFF914aaa), fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.all(10)),
              RaisedButton(
                onPressed: (){
                  _alert();
                  print("Me pachuraron bro :(");
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
                    child: Text('Finalizar',
                      style: TextStyle(
                      fontSize:20,
                      color: Colors.white
                      ),
                    )
                  )
              )
            ],
          ),
        ),
      ),
      )
    );
  }

  void _alert(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: (Text('Finalizar viaje.')),
          content: Text('haz finalizado el viaje y los datos se guardaran en la base de datos'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                SystemNavigator.pop();
              }, 
              child: Text('Finalizar')
            )
          ],          
        );
      }
    );           
  }
   
  void _trackingDevice(a, b){
    try {
      databaseReference
        .collection('Tracking')
        .document(widget.id)
        .updateData({'recorrido': FieldValue.arrayUnion([a,GeoPoint(a, b)])});
    } catch (e) {
      print(e.toString());
    }
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

