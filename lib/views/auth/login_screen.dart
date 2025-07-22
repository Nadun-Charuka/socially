import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';
import 'package:socially/widgets/reuseable/custom_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Image.asset(
                "assets/logo.png",
                height: 70,
              ),
              SizedBox(height: 60),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    CustomInput(
                      controller: _emailController,
                      lableText: "email",
                      icon: Icons.email,
                      obsecureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    CustomInput(
                      controller: _passwordController,
                      lableText: "password",
                      icon: Icons.password,
                      obsecureText: true,
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
                    CustomButton(
                      text: "Log in",
                      width: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          //todo firebase login
                        }
                      },
                    ),
                    Text(
                      "Use google account to Sing In",
                      style: TextStyle(
                        fontSize: 13,
                        color: mainWhiteColor.withValues(alpha: 0.6),
                      ),
                    ),
                    CustomButton(
                      text: "Sign in with Google",
                      width: MediaQuery.of(context).size.width,
                      onPressed: () {
                        //todo google login
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).go("/register");
                      },
                      child: Text(
                        "Or create new accout",
                        style: TextStyle(
                          fontSize: 13,
                          color: mainWhiteColor.withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
