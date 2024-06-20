import 'dart:io';

import 'package:blogs_app/core/permissions/storage_permission.dart';
import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:blogs_app/core/utils/utils.dart';
import 'package:blogs_app/features/blogs/presentation/widgets/blog_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AddBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddBlogPage(),
      );

  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final galleryPermission = await Permissions.getStoragePermission(context);

    if (galleryPermission) {
      final pickedImage = await Utils.pickImage();
      if (pickedImage != null) {
        setState(() {
          image = pickedImage;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Blog'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                image != null
                    ? GestureDetector(
                        onTap: selectImage,
                        child: SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImage,
                        child: DottedBorder(
                          color: AppPallete.borderColor,
                          dashPattern: const [10, 4],
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Select your image',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: //Constants.topics
                        [
                      'Education',
                      'Technology',
                      'News',
                      'Politics',
                      'Employement',
                      'History',
                      'Weather'
                    ]
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectedTopics.contains(e)
                                        ? const MaterialStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(height: 10),
                BlogTextField(
                  controller: titleController,
                  hintText: 'Blog title',
                ),
                const SizedBox(height: 10),
                BlogTextField(
                  controller: contentController,
                  hintText: 'Blog content',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
