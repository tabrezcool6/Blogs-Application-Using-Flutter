import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlogUsecase implements UseCase<String, DeleteBlogParams> {
  final BlogRepository blogRepository;
  DeleteBlogUsecase(this.blogRepository);

  @override
  Future<Either<Failure, String>> call(DeleteBlogParams params) async {
    return await blogRepository.deleteBlog(blogId: params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  DeleteBlogParams({required this.blogId});
}
