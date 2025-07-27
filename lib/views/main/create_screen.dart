import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/providers/user_provider.dart';
import 'package:socially/services/feed/feed_services.dart';
import 'package:socially/utils/functions/common.dart';
import 'package:socially/utils/functions/mood.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';
import 'package:socially/widgets/reuseable/custom_input.dart';

class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key});

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  final _captionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Mood _selectedMood = Mood.happy;
  bool _isUploading = false;
  File? _imageFile;

  Future<void> _pickedImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUserAsync = ref.watch(appUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: appUserAsync.when(
            data: (appUser) => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  CustomInput(
                    controller: _captionController,
                    labelText: "Caption",
                    icon: Icons.text_fields,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter valid caption";
                      } else {
                        return null;
                      }
                    },
                  ),
                  DropdownButton<Mood>(
                    value: _selectedMood,
                    items: Mood.values.map((Mood mood) {
                      return DropdownMenuItem(
                        value: mood,
                        child: Text("${mood.name} ${mood.emoji}"),
                      );
                    }).toList(),
                    onChanged: (mood) {
                      setState(() {
                        _selectedMood = mood!;
                      });
                    },
                  ),
                  _imageFile != null
                      ? ClipRRect(
                          child: kIsWeb
                              ? Image.network(_imageFile!.path)
                              : SizedBox(
                                  height: 300,
                                  child: Image.file(_imageFile!),
                                ),
                        )
                      : Text("No Image selected"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: "Use Camera",
                        width: MediaQuery.of(context).size.width * 0.4,
                        onPressed: () => _pickedImage(ImageSource.camera),
                      ),
                      CustomButton(
                        text: "Use Gallery",
                        width: MediaQuery.of(context).size.width * 0.4,
                        onPressed: () => _pickedImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    text: kIsWeb
                        ? "Not supported"
                        : _isUploading
                            ? "Uploading...."
                            : "Post",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_imageFile != null) {
                          setState(() => _isUploading = true);

                          // 1. Upload the image first
                          final postUrl = await FeedServices()
                              .uploadPostImage(_imageFile!, appUser!.uid);

                          debugPrint("imgade uploaded: $postUrl ");

                          if (postUrl == null) {
                            setState(() => _isUploading = false);
                            return;
                          }

                          // 2. Create a unique post ID
                          final postId = FirebaseFirestore.instance
                              .collection("feeds")
                              .doc()
                              .id;

                          // 3. Save the post to Firestore
                          final newPost = PostModel(
                            postCaption: _captionController.text.trim(),
                            mood: _selectedMood,
                            userId: appUser.uid,
                            username: appUser.name,
                            likes: 0,
                            postId: postId,
                            datePublished: DateTime.now(),
                            postUrl: postUrl,
                            profImage: appUser.photoUrl,
                          );

                          await FeedServices().savePost(newPost);

                          if (context.mounted) {
                            showSnackBar(
                                text: "Post created successfully",
                                context: context);
                          }

                          setState(() {
                            _isUploading = false;
                            _captionController.clear();
                            _imageFile = null;
                            _selectedMood = Mood.happy;
                          });
                        } else {
                          showSnackBar(
                            text: "please Upload a Image",
                            context: context,
                            isWarn: true,
                          );
                        }
                      }
                    },
                  )
                ],
              ),
            ),
            loading: () => CircularProgressIndicator(),
            error: (e, _) => Text("Error loading user"),
          ),
        ),
      ),
    );
  }
}
