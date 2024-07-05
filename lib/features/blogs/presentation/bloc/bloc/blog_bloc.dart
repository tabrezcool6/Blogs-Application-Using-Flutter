import 'dart:io';

import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/usecases/delete_blog_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/fetch_blogs_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/update_blogs_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/upload_blog_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final FetchBlogs _fetchBlogs;
  final UpdateBlogs _updateBlogs;
  final DeleteBlog _deleteBlog;
  BlogBloc({
    required UploadBlog uploadBlog,
    required FetchBlogs fetchBlogs,
    required UpdateBlogs updateBlogs,
    required DeleteBlog deleteBlog,
  })  : _uploadBlog = uploadBlog,
        _fetchBlogs = fetchBlogs,
        _updateBlogs = updateBlogs,
        _deleteBlog = deleteBlog,
        super(
          BlogInitial(),
        ) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogUploadEvent>(_onBlogUpload);

    on<BlogsFetchEvent>(_onFetchBlogs);

    on<BlogUpdateEvent>(_onBlogUpdate);

    on<BlogDeleteEvent>(_onBlogDelete);
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final response = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        imageUrl: event.imageUrl,
        topics: event.topics,
      ),
    );

    response.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchBlogs(BlogsFetchEvent event, Emitter<BlogState> emit) async {
    final response = await _fetchBlogs(NoParams());

    response.fold(
      (l) => emit(BlogFailure(l.message)),
      (blogs) => emit(BlogFetchSuccess(blogs)),
    );
  }

  /// Update Blog
  void _onBlogUpdate(BlogUpdateEvent event, Emitter<BlogState> emit) async {
    final response = await _updateBlogs(
      BlogUpdateParams(
        title: event.title,
        blogId: event.blogId,
      ),
    );

    response.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUpdateSuccess()),
    );
  }

  ///

  void _onBlogDelete(BlogDeleteEvent event, Emitter<BlogState> emit) async {
    final result = await _deleteBlog(DeleteBlogParams(blogId: event.blogId));
    result.fold(
      (l) => emit(BlogFailure(l.message)),
      (blogs) => emit(BlogDeleteSuccess()),
    );
  }
}
