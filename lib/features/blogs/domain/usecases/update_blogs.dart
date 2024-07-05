import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBlogs implements UseCase<Blog, BlogUpdateParams> {
  BlogRepository blogRepository;
  UpdateBlogs(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(params) async {
    return await blogRepository.updateBlog(
      title: params.title,
      blogId: params.blogId,
      // content: params.content,
      // image: params.imageUrl,
      // topics: params.topics,
    );
  }
}

class BlogUpdateParams {
  String? title;
  final String blogId;
  // String? content;
  // File? imageUrl;
  // List<String>? topics;

  BlogUpdateParams({
    this.title,
    required this.blogId,
    // this.content,
    // this.imageUrl,
    // this.topics,
  });
}
