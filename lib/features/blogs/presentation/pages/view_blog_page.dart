import 'package:blogs_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:blogs_app/core/utils.dart';
import 'package:blogs_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blogs/presentation/pages/add_blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewBlogPage extends StatelessWidget {
  static route(String userId, Blog blog) => MaterialPageRoute(
        builder: (context) => ViewBlogPage(
          userId: userId,
          blog: blog,
        ),
      );

  final String userId;
  final Blog blog;
  const ViewBlogPage({required this.userId, required this.blog, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          userId == blog.posterId
              ? IconButton(
                  onPressed: () {
                    Navigator.push(context, AddBlogPage.route(blog: blog));
                    // final posterId = blog.posterId;
                    // print('//// User id $userId');
                    // print('//// Poster id $posterId');
                  },
                  icon: const Icon(Icons.edit))
              : const SizedBox(),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${blog.posterName} ${userId == blog.posterId ? '(me)' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${Utils.formatDateBydMMMYYYY(blog.updatedAt)} . ${Utils.calculateReadTime(blog.content)} min',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(blog.imageUrl),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  blog.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
