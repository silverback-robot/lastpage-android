import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _loading = false;

  void _submitAuth(
    String email,
    String password,
    bool signUp,
    BuildContext ctx,
  ) async {
    setState(() {
      _loading = true;
    });
    try {
      if (signUp) {
        var _authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        var _authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on PlatformException catch (err) {
      var errMsg =
          "Something went wrong. Please check your internet connection.";
      if (err.message != null) {
        errMsg = err.message as String;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            errMsg,
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _loading = false;
      });
    } on FirebaseAuthException catch (err) {
      var errMsg = "Something went wrong. Please check your credentials.";
      if (err.message != null) {
        errMsg = err.message as String;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            errMsg,
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFn: _submitAuth,
        loading: _loading,
      ),
    );
  }
}
