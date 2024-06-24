import 'dart:io';

import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/features/blogs/data/datasource/blog_remote_data_source.dart';
import 'package:uuid/uuid.dart';
import 'package:blogs_app/features/blogs/data/model/blog_model.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogRepositoryImplementation implements BlogRepository {
  final BlogSupabaseDataSource blogSupabaseDataSource;
  BlogRepositoryImplementation(this.blogSupabaseDataSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
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
      final blogs = await blogSupabaseDataSource.fetchBlogs();
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
