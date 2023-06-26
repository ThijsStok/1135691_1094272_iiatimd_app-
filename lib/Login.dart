import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // User is logged in successfully, handle navigation to other screens
      onLoginSuccess(userCredential);
    } catch (e) {
      // Show error message or handle different authentication scenarios
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid email or password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // User is signed up and logged in successfully, handle navigation to other screens
      onLoginSuccess(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      // Show error message or handle different authentication scenarios
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign Up Failed'),
            content: Text('Failed to create an account'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> onLoginSuccess(UserCredential userCredential) async {
    final User user = userCredential.user!;
    final userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!userDataSnapshot.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'email': user.email});
    }
    // Proceed with app navigation or other actions
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _signInWithEmailAndPassword(context),
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _signUpWithEmailAndPassword(context),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
