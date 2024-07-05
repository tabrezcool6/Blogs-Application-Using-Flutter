import 'dart:io';

import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/usecases/fetch_blogs.dart';
import 'package:blogs_app/features/blogs/domain/usecases/update_blogs.dart';
import 'package:blogs_app/features/blogs/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final FetchBlogs _fetchBlogs;
  final UpdateBlogs _updateBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required FetchBlogs fetchBlogs,
    required UpdateBlogs updateBlogs,
  })  : _uploadBlog = uploadBlog,
        _fetchBlogs = fetchBlogs,
        _updateBlogs = updateBlogs,
        super(
          BlogInitial(),
        ) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogUploadEvent>(_onBlogupload);

    on<BlogsFetchEvent>(_onFetchBlogs);

    on<BlogUpdateEvent>(_onBlogUpdate);
  }

  void _onBlogupload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final response = await _uploadBlog(
      UploadBlogParama(
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
}
