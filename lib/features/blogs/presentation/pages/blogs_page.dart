import 'package:blogs_app/features/blogs/presentation/pages/add_blog_page.dart';
import 'package:flutter/material.dart';

class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, AddBlogPage.route()),
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
    );
  }
}
