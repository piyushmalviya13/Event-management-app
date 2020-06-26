import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:include/models/event.dart';
import 'package:intl/intl.dart';

class UpdateEvent extends StatefulWidget {
  @override
  _UpdateEventState createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseDatabase _dbref = FirebaseDatabase();
  Newevent eventData;
  Map data = {};

  var dateformatter = new DateFormat('yMMMd');

  String formatTime(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

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
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Update event"),
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
    data = ModalRoute.of(context).settings.arguments;
    eventData = data['eventData'];
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () => Navigator.pushNamed(context, "/home")),
        title: Text(
          "Update Event",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      initialValue: eventData.venue,
                      validator: (val) => val.isEmpty ? 'Enter a value' : null,
                      onChanged: (value) {
                        setState(() {
                          eventData.venue = value;
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
                      initialValue: eventData.audience,
                      validator: (val) => val.isEmpty ? 'Enter a value' : null,
                      onChanged: (value) {
                        setState(() {
                          eventData.audience = value;
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
                      initialValue: eventData.topic,
                      validator: (val) => val.isEmpty ? 'Enter a value' : null,
                      onChanged: (value) {
                        setState(() {
                          eventData.topic = value;
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
                      initialValue: eventData.speaker,
                      validator: (val) => val.isEmpty ? 'Enter a value' : null,
                      onChanged: (value) {
                        setState(() {
                          eventData.speaker = value;
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
                      initialValue: eventData.details,
                      validator: (val) => val.isEmpty ? 'Enter a value' : null,
                      onChanged: (value) {
                        setState(() {
                          eventData.details = value;
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            value: eventData.permission,
                            onChanged: (value) {
                              setState(() {
                                eventData.permission = value;
                              });
                            }),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Event Report'),
                        trailing: Checkbox(
                            value: eventData.eventReport,
                            onChanged: (value) {
                              setState(() {
                                eventData.eventReport = value;
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
                        String formattedTime = formatTime(time);
                        _dbref
                            .reference()
                            .child('events')
                            .child(eventData.key)
                            .update({
                          "date": date.toString(),
                          "time": formattedTime,
                          "venue": eventData.venue,
                          "topic": eventData.topic,
                          "audience": eventData.audience,
                          "permission": eventData.permission,
                          "eventReport": eventData.eventReport,
                          "speaker": eventData.speaker,
                          "details": eventData.details,
                        });

                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      padding: EdgeInsets.all(12),
                      color: Color(0xff03da9d),
                      child:
                          Text('Update', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}
