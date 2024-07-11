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
  Future<Either<Failure, Blog>> createBlog({
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
        blogId: blogModel.id,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadingBlog = await blogSupabaseDataSource.createBlog(blogModel);

      return right(uploadingBlog);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> readBlog() async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        final blogs = blogLocalDataSource.fetchBlogsLocally();
        return right(blogs);
      }
      final blogs = await blogSupabaseDataSource.readBlog();
      blogLocalDataSource.uploadBlogsLocally(blogs: blogs);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

/// I/flutter ( 5608): ////// print image url: https://qodpzijhkchsxpdoytzk.supabase.co/storage/v1/object/public/blog_images/d0b1d500-f9b8-107c-8340-850a9d1becb2
/// I/flutter ( 5608): ////// print image url: https://qodpzijhkchsxpdoytzk.supabase.co/storage/v1/object/public/blog_images/d0b1d500-f9b8-107c-8340-850a9d1becb2
/// I/flutter ( 5608): ////// print image url: https://qodpzijhkchsxpdoytzk.supabase.co/storage/v1/object/public/blog_images/d0b1d500-f9b8-107c-8340-850a9d1becb2@2024-07-11 12:30:19.347520
/// I/flutter ( 5608): ////// print image url: https://qodpzijhkchsxpdoytzk.supabase.co/storage/v1/object/public/blog_images/a99b78a0-ffe8-107c-8561-f943055cdcf4@2024-07-11 12:46:07.736533



  @override
  Future<Either<Failure, Blog>> updateBlog({
    required Blog blogData,
    required String blogId,
    String? title,
    String? content,
    File? imageUrl,
    List<String>? topics,
  }) async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        return left(Failure(Constants.noInternetConnectionMessage));
      }

      final uploadImageUrl = imageUrl != null
          ? await blogSupabaseDataSource.updateBlogImage(
              blogId: blogId,
              image: imageUrl,
            )
          : blogData.imageUrl;

      print('////// print image url: $uploadImageUrl');

      final uploadingBlog = await blogSupabaseDataSource.updateBlog(
        blogId: blogId,
        title: title,
        content: content,
        imageUrl: uploadImageUrl,
        topics: topics,
      );

      return right(uploadingBlog);
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
