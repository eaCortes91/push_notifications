import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:push_notifications/src/pages/data_tracking.dart';
import 'package:push_notifications/src/pages/delivery_track.dart';


class VerViajesChofer extends StatefulWidget {
  final String name;
  VerViajesChofer({Key key, @required this.name}) : super(key:key);
  

  @override
  _VerViajesChoferState createState() => _VerViajesChoferState();
}

class _VerViajesChoferState extends State<VerViajesChofer> {

  final databaseReference = Firestore.instance;
  var fecha = "";
  var direccion_final = "";
  var direccion_inicial = "";
  var messagge = "";
  var numero = "";
  var a = 1;

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
      //backgroundColor: Colors.black,
       body:StreamBuilder(
            stream: Firestore.instance.collection('Tracking').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(snapshot.data.documents.length);
                    print(widget.name);
                    print(snapshot.data.documents[index].documentID);
                    if(snapshot.data.documents[index].data['repartidor'] == widget.name){
                      if(snapshot.data.documents[index].data['estado'] == 'activo'){
                        
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10,
                          color: Colors.greenAccent[100],
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.drive_eta),
                                title: new Text('ID: '+ snapshot.data.documents[index].documentID),
                                subtitle:  new Text('Fecha: ' + snapshot.data.documents[index].data['fecha'].toDate().toString()),            
                              ),
                              FlatButton(
                                child: const Text('VER'),
                                onPressed: () {
                                  if(snapshot.data.documents[index].data['estado'] == 'activo'){
                                    Navigator.push(context, 
                                  MaterialPageRoute(
                                    builder:(context) => DeliveryTrack(id: snapshot.data.documents[index].documentID, name:snapshot.data.documents[index].data['repartidor'] )));
                                  }
                                  else{
                                    Navigator.push(context, 
                                  MaterialPageRoute(
                                    builder:(context) => DataTracking(id: snapshot.data.documents[index].documentID )));
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                       
                        return  Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        color: Colors.amberAccent[100],
                        child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.drive_eta),
                            title: new Text('ID: '+ snapshot.data.documents[index].documentID),
                            subtitle:  new Text('Fecha: ' + snapshot.data.documents[index].data['fecha'].toDate().toString()), 
                          
                          ),
                          FlatButton(
                            child: const Text('VER'),
                            onPressed: () { 
                              Navigator.push(context, 
                              MaterialPageRoute(
                                builder:(context) => DataTracking(id: snapshot.data.documents[index].documentID )));
                            },
                          ),
                        ],
                      ),
                      );
                      }
                    }
                    
                    else{
                      
                      return Padding(padding: EdgeInsets.all(0));
                    }
                  }
                );
                
             }
          ) 
    );
  }
  
}