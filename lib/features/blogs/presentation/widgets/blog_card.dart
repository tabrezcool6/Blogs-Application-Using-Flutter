import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:blogs_app/core/utils.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/presentation/pages/view_blog_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final String userId;
  final Blog blog;
  const BlogCard({
    super.key,
    required this.userId,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, ViewBlogPage.route(userId, blog)),
      child: Container(
        height: 180,
        margin: const EdgeInsets.all(16).copyWith(
          bottom: 4,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppPallete.gradient1,
              AppPallete.gradient2,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          // color: AppPallete.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Chip(label: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                    color: AppPallete.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'author: ${blog.posterName!}',
                  style: const TextStyle(
                    color: AppPallete.whiteColor,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '${Utils.calculateReadTime(blog.content)} min',
              style: const TextStyle(
                color: AppPallete.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
