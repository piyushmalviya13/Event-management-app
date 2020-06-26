import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:include/screens/wigets/eventTab.dart';
import 'package:include/services/auth.dart';
import 'package:include/models/event.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dateformatter = new DateFormat('yMMMd');

  bool _progressController = true;

  List<Newevent> _eventList = List();

  final AuthService _auth = AuthService();
  final FirebaseDatabase _dbref = FirebaseDatabase.instance;
  DatabaseReference itemref;

  @override
  void initState() {
    super.initState();

    _eventList = new List();

    itemref = _dbref.reference().child("events");
    itemref.onChildAdded.listen(_onEntryAdded);
    itemref.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      _eventList.add(Newevent.fromSnapshot(event.snapshot));
      _progressController = false;
    });
  }

  _onEntryChanged(Event event) {
    var oldEntry = _eventList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _eventList[_eventList.indexOf(oldEntry)] =
          Newevent.fromSnapshot(event.snapshot);
    });
  }

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(new RegExp(r'(\?alt).*'), '');

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }

  _deleteEvent(String eventId, int index) {
    _dbref.reference().child("events").child(eventId).remove().then((_) {
      //print("Delete $todoId successful");
      setState(() {
        _eventList.removeAt(index);
      });
    });
    deleteImage(_eventList[index].imageUrl);

    Navigator.pushReplacementNamed(context, '/home');
  }

  Widget showEventList() {
    if (_eventList.length > 0) {
      return ListView.builder(
        itemCount: _eventList.length,
        itemBuilder: (BuildContext context, int index) {
          var eventDate = DateTime.parse(_eventList[index].date);
          String formattedDate = dateformatter.format(eventDate);
          return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  //color: Colors.black38,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(children: <Widget>[
                EventTab(
                    eventData: _eventList[index],
                    delete: _deleteEvent,
                    index: index),
                ListTile(
                  dense: true,
                  leading: Image.asset('lib/assets/include.png'),
                  title: Text(
                    _eventList[index].topic,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_eventList[index].speaker),
                  trailing: Text(
                      formattedDate.substring(0, formattedDate.length - 6)),
                )
              ]));
        },
      );
    } else {
      return Center(child: Text("No Events"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffefefe),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 30,
            right: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  constraints: BoxConstraints(maxHeight: 70),
                  child: Image.asset('lib/assets/logo.png')),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Visibility(
            visible: !_progressController,
            child: Container(
                margin: const EdgeInsets.only(top: 100.0),
                child: showEventList()),
          ),
          Visibility(
            visible: _progressController,
            child: Center(
              child: SpinKitWave(
                color: Colors.black,
                size: 50.0,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/event');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
