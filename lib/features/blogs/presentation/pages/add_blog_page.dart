import 'dart:io';

import 'package:blogs_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/common/services/storage_permission.dart';
import 'package:blogs_app/core/constants.dart';
import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:blogs_app/core/utils.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blogs/presentation/pages/blogs_page.dart';
import 'package:blogs_app/features/blogs/presentation/widgets/blog_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlogPage extends StatefulWidget {
  static route({blog}) => MaterialPageRoute(
        builder: (context) => AddBlogPage(blog: blog),
      );

  final Blog? blog;
  const AddBlogPage({super.key, this.blog});

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
    File? pickedImage;
    if (Platform.isAndroid) {
      final galleryPermission = await Permissions.getStoragePermission();

      if (galleryPermission) {
        pickedImage = await Utils.pickImage();
        if (pickedImage != null) {
          setState(() {
            image = pickedImage;
          });
        }
      } else {
        if (mounted) {
          Utils.showSnackBar(context, 'Storage permission required');
        }
      }
    } else {
      pickedImage = await Utils.pickImage();
      if (pickedImage != null) {
        setState(() {
          image = pickedImage;
        });
      }
    }
    print('//// IMAGE $pickedImage');
    print('//// IMAGE ${widget.blog!.imageUrl}');
  }

  void uploadBlogOnTap() {
    if (widget.blog == null) {
      if (formKey.currentState!.validate()) {
        if (image == null) {
          Utils.showSnackBar(context, 'Image is required');
        } else if (selectedTopics.isEmpty) {
          Utils.showSnackBar(context, 'Atleast one topic must be selected');
        } else {
          final posterId =
              (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

          context.read<BlogBloc>().add(
                BlogUploadEvent(
                  posterId: posterId,
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  imageUrl: image!,
                  topics: selectedTopics,
                ),
              );
        }
      }
    } else {
      print('/// Updateing funtion');
      print(
          '/// ${titleController.text.trim()} \n${titleController.text.trim()} \n$image! \n$selectedTopics ');
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
    final blogData = widget.blog;
    if (widget.blog != null) {
      selectedTopics = blogData!.topics;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(!(blogData == null) ? 'New Blog' : 'Edit Blog'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: uploadBlogOnTap,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            Utils.showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Utils.showSnackBar(context, 'Blog uploaded successfully');

            Navigator.pushAndRemoveUntil(
              context,
              BlogsPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    (blogData == null)
                        ? image != null
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              )
                        : image != null
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
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      blogData.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),

                    ///
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.blogTopics
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
                                        ? const WidgetStatePropertyAll(
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
                      controller: (blogData == null)
                          ? titleController
                          : TextEditingController(text: blogData.title),
                      hintText: 'Blog title',
                    ),
                    const SizedBox(height: 10),
                    BlogTextField(
                      controller: (blogData == null)
                          ? contentController
                          : TextEditingController(text: blogData.content),
                      hintText: 'Blog content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/*

import 'dart:io';

import 'package:blogs_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/common/services/storage_permission.dart';
import 'package:blogs_app/core/constants.dart';
import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:blogs_app/core/utils.dart';
import 'package:blogs_app/features/blogs/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blogs/presentation/pages/blogs_page.dart';
import 'package:blogs_app/features/blogs/presentation/widgets/blog_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    if (Platform.isAndroid) {
      final galleryPermission = await Permissions.getStoragePermission();

      if (galleryPermission) {
        final pickedImage = await Utils.pickImage();
        if (pickedImage != null) {
          setState(() {
            image = pickedImage;
          });
        }
      } else {
        Utils.showSnackBar(context, 'Storage permission required');
      }
    } else {
      final pickedImage = await Utils.pickImage();
      if (pickedImage != null) {
        setState(() {
          image = pickedImage;
        });
      }
    }
  }

  void uploadBlogOnTap() {
    if (formKey.currentState!.validate()) {
      if (image == null) {
        Utils.showSnackBar(context, 'Image is required');
      } else if (selectedTopics.isEmpty) {
        Utils.showSnackBar(context, 'Atleast one topic must be selected');
      } else {
        final posterId =
            (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

        context.read<BlogBloc>().add(
              BlogUploadEvent(
                posterId: posterId,
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                imageUrl: image!,
                topics: selectedTopics,
              ),
            );
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
          IconButton(
            onPressed: uploadBlogOnTap,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            Utils.showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Utils.showSnackBar(context, 'Blog uploaded successfully');

            Navigator.pushAndRemoveUntil(
              context,
              BlogsPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
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
                        children: Constants.blogTopics
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
          );
        },
      ),
    );
  }
}


 */