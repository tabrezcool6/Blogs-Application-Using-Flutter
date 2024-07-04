import 'dart:io';

import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> fetchBlogs();

  // Future<Either<Failure, Blog>> updateBlog({
  //   required File image,
  //   required String title,
  //   required String content,
  //   required String posterId,
  //   required List<String> topics,
  // });
}
