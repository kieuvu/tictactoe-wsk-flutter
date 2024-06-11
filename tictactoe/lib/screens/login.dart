import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/screens/list_room.dart';
import 'package:tictactoe/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isSignUp = false;

  Future<void> _handle(BuildContext context) async {
    User? user = _isSignUp
        ? await AuthService.register(_emailController.text, _passwordController.text)
        : await AuthService.login(_emailController.text, _passwordController.text);
    if (user != null) {
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ListRoomScreen(),
            ));
      }
    } else {
      log("Error when sign up");
    }
    return;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Tictactoe'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    _isSignUp
                        ? TextFormField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Enter your confirm password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your confirm password';
                              }
                              if (value != _passwordController.text) {
                                return 'Confirm password not match';
                              }
                              return null;
                            },
                            obscureText: true,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handle(context),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                        child: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                        onTap: () => setState(() => _isSignUp = !_isSignUp),
                        child: Text(!_isSignUp ? 'Don\'t have an account? Sign Up' : 'Have an account? Sign In',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            )))
                  ]))));
}
