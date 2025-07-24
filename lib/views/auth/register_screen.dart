import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socially/providers/auth_provider.dart';
import 'package:socially/services/user/user_services.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';
import 'package:socially/widgets/reuseable/custom_input.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  File? _imageFile;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
      debugPrint("Image picked successfull");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);
    final userService = UserService();

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
                  Center(
                    child: Stack(
                      children: [
                        _imageFile != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: FileImage(_imageFile!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTtKDBHoGq6L5htfFMFrluklPkLsQd4e3PAg&s",
                                ),
                              ),
                        Positioned(
                          bottom: -10,
                          right: -5,
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo,
                                color: Colors.white),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return SafeArea(
                                    child: Wrap(
                                      children: <Widget>[
                                        ListTile(
                                          leading:
                                              const Icon(Icons.photo_library),
                                          title: const Text('Photo Library'),
                                          onTap: () {
                                            pickImage(ImageSource.gallery);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(Icons.photo_camera),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            pickImage(ImageSource.camera);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomInput(
                    controller: _nameController,
                    labelText: "Name",
                    icon: Icons.person,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: _emailController,
                    labelText: 'Email',
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
                    labelText: 'Password',
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
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    icon: Icons.lock,
                    obscureText: true,
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
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Sign Up',
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registering...')),
                        );

                        try {
                          final user = await authService.registerWithEmail(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text,
                          );

                          if (user != null) {
                            String finalPhotoUrl =
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTtKDBHoGq6L5htfFMFrluklPkLsQd4e3PAg&s';

                            if (_imageFile != null) {
                              debugPrint(
                                  'Image file selected: ${_imageFile!.path}');
                              String? uploadedUrl =
                                  await userService.uploadProfileImage(
                                _imageFile!,
                                user.uid,
                              );
                              if (uploadedUrl != null) {
                                finalPhotoUrl = uploadedUrl;
                              } else {
                                debugPrint(
                                    'Image upload failed, falling back to default.');
                              }
                            } else {
                              debugPrint(
                                  'No image file selected. Using default.');
                            }

                            await userService.createUserProfile(
                              user,
                              _nameController.text,
                              false,
                              photoUrl: finalPhotoUrl,
                            );
                            debugPrint(
                                'DEBUG: User profile created/updated in Firestore with final photoUrl. photoUrl :$finalPhotoUrl');

                            // Success!
                            _emailController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                            _nameController.clear();
                            setState(() {
                              _imageFile = null;
                            });

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Registration successful!')),
                              );
                            }
                            if (context.mounted) GoRouter.of(context).go('/');
                          }
                        } on FirebaseAuthException catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        } catch (e) {
                          debugPrint('Registration/Upload Error: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'An unexpected error occurred during registration.')),
                            );
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).go("/login");
                    },
                    child: const Text(
                      'Already have an account? Log in',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
