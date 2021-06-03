import 'package:FlutterChat/screens/conversion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _isLoading = false;

  //Submit AuthCredential Function

  Future<void> submitAuthForm(String? email, String? password, String username,
      File? image, bool? isLogin, BuildContext ctx) async {

    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin!) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email!, password: password!);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConversionScreen()));

      } else {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email!, password: password!); 
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConversionScreen()));

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(userCredential.user!.uid + '.jpg');

        await ref.putFile(image!).whenComplete(() => print('Image Upload'));

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl': url,
        });
      }
    } on PlatformException catch (error) {
      dynamic message = 'An error occured, please check your credentials!';

      if (error.message != null) {
        message = error.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitAuthForm, _isLoading),
    );
  }
}
