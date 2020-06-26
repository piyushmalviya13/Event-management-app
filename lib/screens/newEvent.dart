import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:include/models/event.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseDatabase _dbref = FirebaseDatabase();
  StorageReference storage;
  var posterImage;
  bool uploading = false;

  Future pickImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      posterImage = tempImage;
    });
  }

  var dateformatter = new DateFormat('yMMMd');

  String formatTime(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String venue = "";
  String audience = "";
  String topic = "";
  String speaker = "";
  bool permission = false;
  bool eventReport = false;
  String details = "";

  _pickDate() async {
    DateTime d = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDate: date);
    if (d != null)
      setState(() {
        date = d;
      });
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("No Image Uploaded"),
      content: Text("Please upload the poster image"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showConfirmationAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        setState(() {
          uploading = true;
        });
        Navigator.of(context).pop();
        storage = FirebaseStorage.instance.ref().child("posterImages/$topic");
        final StorageUploadTask uploadTask = storage.putFile(posterImage);
        final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
        final String url = (await downloadUrl.ref.getDownloadURL());

        String formattedTime = formatTime(time);
        Newevent event = new Newevent(date.toString(), formattedTime, venue,
            topic, audience, permission, eventReport, speaker, details, url);
        _dbref.reference().child("events").push().set(event.toJson());

        Navigator.pushReplacementNamed(context, '/home');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Add event?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () => Navigator.pushNamed(context, "/home")),
        title: uploading
            ? Text(
                "Uploading Data",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              )
            : Text(
                "New Event",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
      ),
      body: uploading
          ? Center(
              child: SpinKitChasingDots(
                color: Colors.black,
                size: 100.0,
              ),
            )
          : SingleChildScrollView(
              child: Column(children: <Widget>[
                posterImage == null
                    ? Text('')
                    : Container(
                        margin: EdgeInsets.all(20),
                        constraints: BoxConstraints.expand(
                          height: 170.0,
                        ),
                        //padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(posterImage),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
                      pickImage();
                    },
                    padding: EdgeInsets.all(4),
                    color: Colors.white,
                    child: Text('Upload Image',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            autofocus: false,
                            initialValue: '',
                            validator: (val) =>
                                val.isEmpty ? 'Enter a value' : null,
                            onChanged: (value) {
                              setState(() {
                                venue = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Event Venue',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
                        ),
                        //SizedBox(height: 15.0),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            autofocus: false,
                            initialValue: '',
                            validator: (val) =>
                                val.isEmpty ? 'Enter a value' : null,
                            onChanged: (value) {
                              setState(() {
                                audience = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Audience',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
                        ),
                        //SizedBox(height: 15.0),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            autofocus: false,
                            initialValue: '',
                            validator: (val) =>
                                val.isEmpty ? 'Enter a value' : null,
                            onChanged: (value) {
                              setState(() {
                                topic = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Topic of event',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            autofocus: false,
                            initialValue: '',
                            validator: (val) =>
                                val.isEmpty ? 'Enter a value' : null,
                            onChanged: (value) {
                              setState(() {
                                speaker = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Speaker',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            autofocus: false,
                            initialValue: '',
                            validator: (val) =>
                                val.isEmpty ? 'Enter a value' : null,
                            onChanged: (value) {
                              setState(() {
                                details = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Event Details',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 4.0,
                              onPressed: () => _pickDate(),
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 18.0,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                dateformatter.format(date),
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "  Change",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            )),

                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 4.0,
                              onPressed: () => _pickTime(),
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 18.0,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                formatTime(time),
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "  Change",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            )),
                        //SizedBox(height: 8.0),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Permission Letter'),
                              trailing: Checkbox(
                                  value: permission,
                                  onChanged: (value) {
                                    setState(() {
                                      permission = value;
                                    });
                                  }),
                            )),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Event Report'),
                              trailing: Checkbox(
                                  value: eventReport,
                                  onChanged: (value) {
                                    setState(() {
                                      eventReport = value;
                                    });
                                  }),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              if (posterImage == null) {
                                showAlertDialog(context);
                              }
                              if (_formKey.currentState.validate()) {
                                showConfirmationAlertDialog(context);
                              }
                            },
                            padding: EdgeInsets.all(12),
                            color: Color(0xff03da9d),
                            child: Text('Submit',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    )),
              ]),
            ),
    );
  }
}
