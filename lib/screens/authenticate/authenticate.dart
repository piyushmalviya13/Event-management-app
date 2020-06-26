import 'package:include/screens/authenticate/register.dart';
import 'package:include/screens/authenticate/sign_in.dart';

import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleState() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == true) {
      return SignIn(toggleState: toggleState);
    } else {
      return Register(toggleState: toggleState);
    }
  }
}
