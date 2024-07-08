import 'dart:io';

import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> createBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> readBlog();

  Future<Either<Failure, Blog>> updateBlog({
    required String blogId,
    String? title,
    String? content,
    File? imageUrl,
    List<String>? topics,
  });

  Future<Either<Failure, String>> deleteBlog({
    required String blogId,
  });
}
