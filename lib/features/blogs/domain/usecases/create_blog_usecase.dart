import 'dart:io';

import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateBlogUsecase implements UseCase<Blog, CreateBlogParams> {
  final BlogRepository blogRepository;
  CreateBlogUsecase(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(CreateBlogParams params) async {
    return await blogRepository.createBlog(
      image: params.imageUrl,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class CreateBlogParams{
  final String posterId;
  final String title;
  final String content;
  final File imageUrl;
  final List<String> topics;

  CreateBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
  });
}
