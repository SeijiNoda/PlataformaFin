import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signinbutton extends StatefulWidget {

  final TextEditingController? emailcontroller;
  final TextEditingController? passwordcontroller;

  const Signinbutton({super.key, this.emailcontroller, this.passwordcontroller});

  @override
  State<Signinbutton> createState() => _SigninbuttonState();
}

class _SigninbuttonState extends State<Signinbutton> {

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.emailcontroller!.text.trim(),
        password: widget.passwordcontroller!.text.trim(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: signIn,
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12), 
          ),
          child: const Center(
            child: Text(
              "Entrar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ),
      ),
    );
  }
}