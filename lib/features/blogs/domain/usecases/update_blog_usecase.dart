import 'dart:io';

import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBlogUsecase implements UseCase<Blog, UpdateBlogParams> {
  BlogRepository blogRepository;
  UpdateBlogUsecase(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(params) async {
    return await blogRepository.updateBlog(
      title: params.title,
      blogId: params.blogId,
      content: params.content,
      imageUrl: params.imageUrl,
      topics: params.topics,
    );
  }
}

class UpdateBlogParams {
  final String blogId;
  String? title;
  String? content;
  File? imageUrl;
  List<String>? topics;

  UpdateBlogParams({
    required this.blogId,
    this.title,
    this.content,
    this.imageUrl,
    this.topics,
  });
}
