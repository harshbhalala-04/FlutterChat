import 'package:FlutterChat/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversionScreen extends StatefulWidget {
  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Chat'),
          actions: [
            DropdownButton(
                underline: Container(),
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.black,),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Logout'),
                        ],
                      ),
                    ),
                    value: 'Logout',
                  ),
                ],
                onChanged: (itemIndentifier) {
                  if (itemIndentifier == 'Logout') {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AuthScreen()));
                  }
                })
          ],
        ),
        body: Center(
          child: Text('Conversion Screen'),
        ));
  }
}
