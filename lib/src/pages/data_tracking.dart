import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataTracking extends StatefulWidget {
  final String id;
  DataTracking({Key key, @required this.id}) : super(key:key);

  @override
  _DataTrackingState createState() => _DataTrackingState();
}

class _DataTrackingState extends State<DataTracking> {

  final databaseReference = Firestore.instance;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CustomPaint(
       painter: _HeaderCurvoPainter(),
       child: Center(
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Divider(
                  color: Colors.red
                ),
                
                StreamBuilder(
                  stream: Firestore.instance
                    .collection("Tracking")
                    .document(widget.id)
                    .snapshots(),
                  builder: (context, f) {
                    if (f.hasData) {    
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text( 'Inicio: ${f.data['direccion_inicial']}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xffc75090)
                            ),
                          textAlign: TextAlign.center,),
                          Text( 'Destino: ${f.data['direccion_final']}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xffc75090)
                            ),
                          textAlign: TextAlign.center,),
                          Text( 'Usuario: ${f.data['user']}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xffc75090)
                            ),
                          textAlign: TextAlign.center,),
                          Text( 'Teléfono: ${f.data['numero']}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xffc75090)
                            ),
                          textAlign: TextAlign.center,),
                          Text( 'Mensaje: ${f.data['message']}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xffc75090)
                            ),
                          textAlign: TextAlign.center,),
                          Text( 'ID: ${f.data['id']}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xffc75090)
                            ),
                          textAlign: TextAlign.center,),
                          Text( 'Repartidor: ${f.data['repartidor']}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xffc75090)
                            ),
                          textAlign: TextAlign.center,),
                          Text( 'Estatus: ${f.data['estado']}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color(0xffc75090)
                            ),
                          textAlign: TextAlign.center,),
                        ],
                      );
                    }else{
                      return Text('No se encuentran los datos, verifica tu conneccion a internet');
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                Divider(
                  color: Colors.red
                ),
                Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children:<Widget>[
                  
                Padding(padding: EdgeInsets.all(10)),
                
               ])
              ],
            ),
          )
      ),
     ) 
    );
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