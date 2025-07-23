import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socially/providers/auth_provider.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';
import 'package:socially/widgets/reuseable/custom_input.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              "assets/logo.png",
              height: 70,
            ),
            const SizedBox(height: 60),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInput(
                    controller: _emailController,
                    labelText: "Email",
                    icon: Icons.email,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: _passwordController,
                    labelText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: "Log in",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          await authService.loginWithEmail(
                            _emailController.text,
                            _passwordController.text,
                          );
                        } on FirebaseAuthException catch (e) {
                          String message;
                          if (e.code == 'user-not-found') {
                            message = "No user found for that email.";
                          } else if (e.code == 'wrong-password') {
                            message = "Wrong password. Please try again.";
                          } else if (e.code == 'invalid-email') {
                            message = "The email address is not valid.";
                          } else {
                            message = "Login failed: ${e.message}";
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('An unexpected error occurred.')),
                            );
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Or sign in with Google",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: "Sign in with Google",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      try {
                        await authService.loginWithGoogle();
                      } on FirebaseAuthException catch (e) {
                        String message = "Google Sign-In failed.";
                        if (e.code ==
                            'account-exists-with-different-credential') {
                          message =
                              "An account already exists with this email using a different login method.";
                        } else {
                          message = "Google Sign-In failed: ${e.message}";
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'An unexpected error occurred with Google Sign-In.')),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).go("/register");
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
