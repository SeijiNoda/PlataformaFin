import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';

class MockFirebaseAuthWithCustomErrors extends MockFirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {

    if (email.isEmpty || !email.contains('@') || email.length > 254) {
      throw Exception('Invalid email address.');
    }

    if (password.isEmpty || password.length < 6 || password.length > 128) {
      throw Exception('Invalid password.');
    }
    return super.signInWithEmailAndPassword(email: email, password: password);
  }
}

void main() {
  group('Login', () {
    late MockFirebaseAuthWithCustomErrors mockAuth;
    late TextEditingController emailController;
    late TextEditingController passwordController;

    setUp(() {
      mockAuth = MockFirebaseAuthWithCustomErrors();
      emailController = TextEditingController();
      passwordController = TextEditingController();
    });

    tearDown(() {
      emailController.dispose();
      passwordController.dispose();
    });

    test('Sucesso no login com email e senhas validos', () async {
      emailController.text = 'test@test.com';
      passwordController.text = 'senha123';

      await mockAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await mockAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = mockAuth.currentUser;
      expect(user, isNotNull);
      expect(user?.email, equals('test@test.com'));
    });
  });
}
