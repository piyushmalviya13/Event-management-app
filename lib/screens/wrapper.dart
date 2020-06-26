import 'package:include/screens/authenticate/authenticate.dart';
import 'package:include/screens/home/homepage.dart';
import 'package:include/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
