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
    if (email != 'test@example.com' || password != 'password123') {
      throw Exception('The password is invalid or the user does not have a password.');
    }
    return super.signInWithEmailAndPassword(email: email, password: password);
  }
}

void main() {
  group('SignInbutton tests', () {
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

    test('Login succeeds with valid email and password', () async {
      emailController.text = 'test@example.com';
      passwordController.text = 'password123';

      // Mock the authentication
      await mockAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      await mockAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = mockAuth.currentUser;
      expect(user, isNotNull);
      expect(user?.email, equals('test@example.com'));
    });

    test('Login fails with invalid email', () async {
      emailController.text = 'invalid-email';
      passwordController.text = 'password123';

      expect(
        () async => await mockAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('The password is invalid or the user does not have a password.'),
          ),
        ),
      );
    });

    test('Login fails with wrong password', () async {
      emailController.text = 'test@example.com';
      passwordController.text = 'wrongpassword';

      await mockAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(
        () async => await mockAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('The password is invalid or the user does not have a password.'),
          ),
        ),
      );
    });
  });
}
