import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/views/components/SignInButton.dart';
import 'package:my_app/views/components/TextInput.dart';

class LoginScreen extends StatefulWidget {
    final VoidCallback showRegisterPage;
  const LoginScreen({super.key, required this.showRegisterPage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 100,
                  color: Colors.blue,
                ),
                Text('Plataforma Financeiro',
                    style: GoogleFonts.bebasNeue(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 50),
                TextInput(placeholder: "Email", controller:_emailController),
                const SizedBox(height: 10),
                TextInput(placeholder: "Password", obscureText: true, controller:_passwordController),
                const SizedBox(height: 10),
                Signinbutton(emailcontroller: _emailController, passwordcontroller: _passwordController),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: const Text(
                    'Cadastre-se',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
