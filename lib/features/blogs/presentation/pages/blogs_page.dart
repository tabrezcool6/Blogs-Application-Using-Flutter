import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:blogs_app/core/utils.dart';
import 'package:blogs_app/features/blogs/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blogs/presentation/pages/add_blog_page.dart';
import 'package:blogs_app/features/blogs/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogsPage());
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogsFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.logout_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, AddBlogPage.route()),
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            Utils.showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          if (state is BlogFetchSuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blogs = state.blogs[index];
                return BlogCard(
                  blog: blogs,
                  color: Colors.blue.shade400,
                ); // Text(blogs.title);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
