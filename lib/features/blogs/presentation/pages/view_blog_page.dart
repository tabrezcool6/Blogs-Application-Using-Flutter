import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:blogs_app/core/utils.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blogs/presentation/pages/add_blog_page.dart';
import 'package:blogs_app/features/blogs/presentation/pages/blogs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// git fetch origin 'updateBlogFeature_tabrezcool6':'local_updateBlogFeature_tabrezcool6'

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
            /// Edit Blog Icon Button
            userId == blog.posterId
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        AddBlogPage.route(blog: blog),
                      );
                    },
                    icon: const Icon(Icons.edit))
                : const SizedBox(),

            /// Delete Blog Icon Button
            userId == blog.posterId
                ? IconButton(
                    onPressed: () {
                      print('//// User id $userId \nblog id ${blog.id}');

                      context
                          .read<BlogBloc>()
                          .add(BlogDeleteEvent(blogId: blog.id));
                    },
                    icon: const Icon(Icons.delete))
                : const SizedBox(),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(listener: (context, state) {
          if (state is BlogDeleteSuccess) {
            Utils.showSnackBar(context, 'Blog deleted successfully');

            Navigator.pushAndRemoveUntil(
              context,
              BlogsPage.route(),
              (route) => false,
            );
          }
        }, builder: (context, state) {
          return Scrollbar(
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
          );
        }));
  }
}
