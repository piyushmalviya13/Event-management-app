import 'package:include/models/user.dart';
import 'package:include/screens/newEvent.dart';
import 'package:include/screens/updateEvent.dart';
import 'package:include/screens/wigets/eventTabModal.dart';
import 'package:include/screens/wrapper.dart';
import 'package:include/screens/home/homepage.dart';
import 'package:include/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Color primaryColor = Colors.blue;
  final Color accentColor = Color(0xff333333);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(color: Colors.white),
          fontFamily: 'Rubik',
          //textTheme: ,
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            textTheme: ButtonTextTheme.normal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.all(8),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(style: BorderStyle.none),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        home: Wrapper(),
        routes: {
          '/event': (context) => NewEvent(),
          '/home': (context) => Home(),
          '/eventModal': (context) => EventTabModal(),
          '/updateEvent': (context) => UpdateEvent(),
        },
      ),
    );
  }
}
