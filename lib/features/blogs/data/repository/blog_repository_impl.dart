import 'dart:io';

import 'package:blogs_app/core/constants.dart';
import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/features/blogs/data/datasource/blog_local_data_source.dart';
import 'package:blogs_app/features/blogs/data/datasource/blog_supabase_data_source.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:blogs_app/features/blogs/data/model/blog_model.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogRepositoryImplementation implements BlogRepository {
  final BlogSupabaseDataSource blogSupabaseDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final InternetConnection internetConnection;

  BlogRepositoryImplementation(
    this.blogSupabaseDataSource,
    this.blogLocalDataSource,
    this.internetConnection,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        return left(Failure(Constants.noInternetConnectionMessage));
      }

      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogSupabaseDataSource.uploadBlogImage(
        image: image,
        blogModel: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadingBlog = await blogSupabaseDataSource.uploadBlog(blogModel);

      return right(uploadingBlog);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> fetchBlogs() async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        final blogs = blogLocalDataSource.fetchBlogsLocally();
        return right(blogs);
      }
      final blogs = await blogSupabaseDataSource.fetchBlogs();
      blogLocalDataSource.uploadBlogsLocally(blogs: blogs);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> deleteBlog({required String blogId}) async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        return left(Failure(Constants.noInternetConnectionMessage));
      }
      await blogSupabaseDataSource.deleteBlog(blogId: blogId);
      return right('deleted');
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
