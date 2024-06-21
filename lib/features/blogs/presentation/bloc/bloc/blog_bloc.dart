import 'dart:io';

import 'package:blogs_app/features/blogs/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  BlogBloc(
    this.uploadBlog,
  ) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogUploadEvent>(_onBlogupload);
  }

  void _onBlogupload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final result = await uploadBlog(
      UploadBlogParama(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        imageUrl: event.imageUrl,
        topics: event.topics,
      ),
    );

    result.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogSuccess()),
    );
  }
}
