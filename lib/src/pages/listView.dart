import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:push_notifications/src/pages/data_tracking.dart';


class VerViajes extends StatefulWidget {
  final String name;
  VerViajes({Key key, @required this.name}) : super(key:key);
  

  @override
  _VerViajesState createState() => _VerViajesState();
}

class _VerViajesState extends State<VerViajes> {

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
      //backgroundColor: Colors.black,
       body:StreamBuilder(
            stream: Firestore.instance.collection('Tracking').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(widget.name);
                    if(snapshot.data.documents[index].data['tienda'] == widget.name){
                     if(snapshot.data.documents[index].data['estado'] == 'activo'){
                        return new Card(
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
                                  Navigator.push(context, 
                                  MaterialPageRoute(
                                    builder:(context) => DataTracking(id: snapshot.data.documents[index].documentID )));
                                },
                              ),
                            ],
                          ),
                        );
                    }
                    else{
                      return new Card(
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