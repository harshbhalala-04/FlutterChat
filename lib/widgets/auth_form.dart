import 'package:flutter/material.dart';
import 'dart:io';
import './user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final Future<void> Function(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  dynamic _userEmail = '';
  dynamic _userName = '';
  dynamic _userPassword;
  File? _userImageFile;

  void _pickedImage(File? image) {
    _userImageFile = image;
  }

  //Form validation and save
  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Select an Image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid!) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail?.trim(),
        _userPassword?.trim(),
        _userName?.trim(),
        _userImageFile!,
        _isLogin,
        context,
      );
    }
  }

  //Form Widget

  @override
  Widget build(BuildContext context) {
    return new Builder(
      builder: (context) {
        return Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (!_isLogin) UserImagePicker(_pickedImage),
                      TextFormField(
                        key: ValueKey('email'),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value?.isEmpty == null || !value!.contains('@')) {
                            return 'Please Enter valid Email Address.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                        ),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                            key: ValueKey('username'),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Username.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                            onSaved: (value) {
                              _userName = value;
                            }),
                      TextFormField(
                          key: ValueKey('password'),
                          validator: (value) {
                            if (value?.isEmpty == null || value!.length < 7) {
                              return 'Password must be atleast 7 characters long';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          onSaved: (value) {
                            _userPassword = value;
                          }),
                      SizedBox(
                        height: 12,
                      ),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        OutlinedButton(
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                          onPressed: _trySubmit,
                          //onPressed: _trySubmit,
                        ),
                      if (!widget.isLoading)
                        TextButton(
                          child: Text(_isLogin
                              ? 'Create a new account'
                              : 'I already have an account'),
                          style: TextButton.styleFrom(primary: Colors.pink),
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
