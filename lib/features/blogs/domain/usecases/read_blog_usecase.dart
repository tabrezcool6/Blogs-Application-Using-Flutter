import 'package:blogs_app/core/error/failures.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';

class ReadBlogUsecase implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  ReadBlogUsecase(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.readBlog();
  }
}
