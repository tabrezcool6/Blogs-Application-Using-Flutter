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
      blogData: params.blogData,
      blogId: params.blogId,
      title: params.title,
      content: params.content,
      imageUrl: params.imageUrl,
      topics: params.topics,
    );
  }
}

class UpdateBlogParams {
  final Blog blogData;
  final String blogId;
  String? title;
  String? content;
  File? imageUrl;
  List<String>? topics;

  UpdateBlogParams({
    required this.blogData,
    required this.blogId,
    this.title,
    this.content,
    this.imageUrl,
    this.topics,
  });
}
