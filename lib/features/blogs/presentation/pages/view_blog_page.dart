import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:blogs_app/core/utils/utils.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class ViewBlogPage extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => ViewBlogPage(blog: blog),
      );

  final Blog blog;
  const ViewBlogPage({required this.blog, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  'By ${blog.posterName}',
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
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
