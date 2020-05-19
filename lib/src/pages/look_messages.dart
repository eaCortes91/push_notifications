import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:push_notifications/src/pages/delivery_track.dart';

class LookMessage extends StatefulWidget {
  final String id;
  LookMessage({Key key, @required this.id}) : super(key:key);

  @override
  _LookMessageState createState() => _LookMessageState();
}

class _LookMessageState extends State<LookMessage> {

  final databaseReference = Firestore.instance;
  String a= 'no hay jefe';

 
  @override
  void initState() { 
    super.initState();
    //_getbool(widget.name);
   
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
                    .collection("Messages")
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
                          textAlign: TextAlign.center,)
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
                  RaisedButton(
                  onPressed: () {
                    
                    _tomarViaje(widget.id);
                    
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
                    child: Text('  Tomar  ',
                      style: TextStyle(
                      fontSize:20,
                      color: Colors.white
                      ),
                    )
                  )    
                ),
                Padding(padding: EdgeInsets.all(10)),
                RaisedButton(
                  onPressed: () {
                    
                    print("Declinado");
                    SystemNavigator.pop();

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
                    child: Text('Declinar',
                      style: TextStyle(
                      fontSize:20,
                      color: Colors.white
                      ),
                    )
                  ),
                )
               ])
              ],
            ),
          )
      ),
     ) 
    ); 
  }

  void _tomarViaje(doc) async {
    DocumentReference documentReference = Firestore.instance
      .collection('Messages').document(doc);

    await documentReference.get().then((datasnapshot){
      if(datasnapshot.exists){
        if(datasnapshot.data['activo'] == 'activo'){
          print('el dato es activo');
          var a = datasnapshot.data['numero'];
          var b = datasnapshot.data['id'];
          var c = datasnapshot.data['message'];
          var d = datasnapshot.data['user'];
          var e = datasnapshot.data['direccion_inicial'];
          var f = datasnapshot.data['direccion_final'];
          print(datasnapshot.data['id'].toString());
          _createRecord(a,b,c,d,e,f);
          _desactivar(b);
          // _borrarMessage(datasnapshot.data['id']);
          Navigator.push(context, 
                      MaterialPageRoute(
                        builder:(context) => DeliveryTrack(id:widget.id)));
        }else{
          print('el dato es inactivo');
          _alert('llegas muy tarde', 'Intentalo la próxima vez.');
        }

      }else{
        print("error");
        _alert('Error, viaje no encontrado', 'No podemos procesar la solicitud');

      }
    });
  
  }
  
  void _createRecord(a,b,c,d,e,f) async {
    //_getCurrentLocation();
    //GeoPoint(position, longitude)
    var fecha = new DateTime.now();
    await databaseReference.collection("Tracking")
      .document(b)
      .setData({

        'numero':a,
        'id':b,
        'message':c,
        'user':d,
        'direccion_inicial':e,
        'direccion_final':f,
        'fecha': fecha,
        'estado':'activo',

      });    
  }

  void _alert(m1, m2){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: (Text(m1)),
          content: Text(m2),
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

   /*void _borrarMessage(data){ 
    try { 
      databaseReference
        .collection('Messages') 
        .document(data) 
        .delete().then((_){
          print(data);
        }); 
    } catch(e) { 
      print(e.toString ()); 
    } 
  }*/

  void _desactivar(b){
    try {
      databaseReference
        .collection('Messages')
        .document(b)
        .updateData({'activo': 'desactivado'});
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