import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/providers/auth_provider.dart';
import 'package:socially/services/auth/auth_services.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';
import 'package:socially/widgets/reuseable/custom_input.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  File? _imageFile;

  //configure image picker
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    Center(
                      child: Stack(
                        children: [
                          _imageFile != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainPurpleColor,
                                  backgroundImage: FileImage(_imageFile!),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainPurpleColor,
                                  backgroundImage: NetworkImage(
                                    "https://i.stack.imgur.com/l60Hf.png",
                                  ),
                                ),
                          Positioned(
                            bottom: -10,
                            right: -5,
                            child: IconButton(
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () async {
                                pickImage(ImageSource.gallery);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomInput(
                      controller: _nameController,
                      lableText: "Name",
                      icon: Icons.person,
                      obsecureText: false,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "please enter your name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    CustomInput(
                      controller: _emailController,
                      lableText: 'Email',
                      icon: Icons.email,
                      obsecureText: false,
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
                    CustomInput(
                      controller: _passwordController,
                      lableText: 'Password',
                      icon: Icons.lock,
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
                    CustomInput(
                      controller: _confirmPasswordController,
                      lableText: 'Confirm Password',
                      icon: Icons.lock,
                      obsecureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    CustomButton(
                        text: 'Sign Up',
                        width: MediaQuery.of(context).size.width,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await authService.registerWithEmail(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                            );
                          }
                        }),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).go("/login");
                      },
                      child: const Text(
                        'Already have an account? Log in',
                        style: TextStyle(color: mainWhiteColor),
                      ),
                    ),
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
