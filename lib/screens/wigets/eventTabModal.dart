import 'package:flutter/material.dart';
import 'package:include/models/event.dart';
import 'package:intl/intl.dart';

class EventTabModal extends StatefulWidget {
  @override
  _EventTabModalState createState() => _EventTabModalState();
}

class _EventTabModalState extends State<EventTabModal> {
  Newevent eventData;
  Function delete;
  int index;
  Map data = {};

  var dateformatter = new DateFormat('yMMMd');

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
      onPressed: () {
        delete(eventData.key, index);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Delete event?"),
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
    delete = data['delete'];
    index = data['index'];
    var eventDate = DateTime.parse(eventData.date);
    String formattedDate = dateformatter.format(eventDate);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Stack(
                children: <Widget>[
                  //SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.menu),
                      onPressed: () async {},
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(20),
              constraints: BoxConstraints.expand(
                height: 170.0,
              ),
              //padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(eventData.imageUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      dense: true,
                      title: Text(
                        eventData.topic,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(eventData.speaker),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: ListTile(
                title: Text('Event Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: //Text(eventData.details),
                    Text(eventData.details),
                //'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain...'),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    //dense: true,
                    leading: Icon(Icons.location_on),
                    title: Text(eventData.venue),
                    subtitle: Text('202'),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    leading: Icon(Icons.schedule),
                    title: Text(
                        formattedDate.substring(0, formattedDate.length - 6)),
                    subtitle: Text(eventData.time),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ListTile(
                leading: Icon(Icons.description),
                title: Text('Permission Letter'),
                trailing: eventData.permission
                    ? Icon(Icons.done, color: Colors.green)
                    : null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ListTile(
                leading: Icon(Icons.book),
                title: Text('Event Report'),
                trailing: eventData.eventReport
                    ? Icon(Icons.done, color: Colors.green)
                    : null,
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/updateEvent',
                              arguments: {
                                'eventData': this.eventData,
                              });
                        },
                        padding: EdgeInsets.all(12),
                        color: Colors.blue,
                        child: Text('Edit Event',
                            style: TextStyle(color: Colors.black)),
                      )),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () async {
                        showConfirmationAlertDialog(context);
                      },
                      padding: EdgeInsets.all(12),
                      color: Colors.red,
                      child: Text('Delete Event',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
