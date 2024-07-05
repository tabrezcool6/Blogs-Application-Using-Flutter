import 'package:blogs_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/utils.dart';
import 'package:blogs_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:blogs_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/auth/presentation/pages/signin_page.dart';
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
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOut());

            Navigator.pushAndRemoveUntil(
              context,
              SignInPage.route(),
              (route) => false,
            );
          },
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
          // else if (state is AuthSignOutSuccess) {
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     SignInPage.route(),
          //     (route) => false,
          //   );
          // }

          if (state is BlogFetchSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<BlogBloc>().add(BlogsFetchEvent());
              },
              child: ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final loggedInUserId =
                      (context.read<AppUserCubit>().state as AppUserLoggedIn)
                          .user
                          .id;
                  final blogs = state.blogs[index];
                  return BlogCard(
                    userId: loggedInUserId,
                    blog: blogs,
                    color: Colors.blue.shade400,
                  ); // Text(blogs.title);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
