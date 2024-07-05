import 'dart:io';

import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/usecases/delete_blog.dart';
import 'package:blogs_app/features/blogs/domain/usecases/fetch_blogs.dart';
import 'package:blogs_app/features/blogs/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final FetchBlogs _fetchBlogs;
  final DeleteBlog _deleteBlog;
  BlogBloc({
    required UploadBlog uploadBlog,
    required FetchBlogs fetchBlogs,
    required DeleteBlog deleteBlog,
  })  : _uploadBlog = uploadBlog,
        _fetchBlogs = fetchBlogs,
        _deleteBlog = deleteBlog,
        super(
          BlogInitial(),
        ) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogUploadEvent>(_onBlogUpload);

    on<BlogsFetchEvent>(_onFetchBlogs);

    on<BlogDeleteEvent>(_onBlogDelete);
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final result = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        imageUrl: event.imageUrl,
        topics: event.topics,
      ),
    );

    result.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchBlogs(BlogsFetchEvent event, Emitter<BlogState> emit) async {
    final result = await _fetchBlogs(NoParams());

    result.fold(
      (l) => emit(BlogFailure(l.message)),
      (blogs) => emit(BlogFetchSuccess(blogs)),
    );
  }

  void _onBlogDelete(BlogDeleteEvent event, Emitter<BlogState> emit) async {
    final result = await _deleteBlog(DeleteBlogParams(blogId: event.blogId));
    print('/// DELETE REPOSNE $result');
    result.fold(
      (l) => emit(BlogFailure(l.message)),
      (blogs) => emit(BlogDeleteSuccess()),
    );
  }
}
