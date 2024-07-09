import 'dart:io';

import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blogs/domain/entities/blog.dart';
import 'package:blogs_app/features/blogs/domain/usecases/delete_blog_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/read_blog_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/update_blog_usecase.dart';
import 'package:blogs_app/features/blogs/domain/usecases/create_blog_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final CreateBlogUsecase _createBlogUsecase;
  final ReadBlogUsecase _readBlogUsecase;
  final UpdateBlogUsecase _updateBlogUsecase;
  final DeleteBlogUsecase _deleteBlogUsecase;
  BlogBloc({
    required CreateBlogUsecase createBlogUsecase,
    required ReadBlogUsecase readBlogUsecase,
    required UpdateBlogUsecase updateBlogUsecase,
    required DeleteBlogUsecase deleteBlogUsecase,
  })  : _createBlogUsecase = createBlogUsecase,
        _readBlogUsecase = readBlogUsecase,
        _updateBlogUsecase = updateBlogUsecase,
        _deleteBlogUsecase = deleteBlogUsecase,
        super(
          BlogInitial(),
        ) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogCreateEvent>(_onBlogCreaete);

    on<BlogReadEvent>(_onBlogRead);

    on<BlogUpdateEvent>(_onBlogUpdate);

    on<BlogDeleteEvent>(_onBlogDelete);
  }

  void _onBlogCreaete(
    BlogCreateEvent event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _createBlogUsecase(
      CreateBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        imageUrl: event.imageUrl,
        topics: event.topics,
      ),
    );

    response.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogCreateSuccess()),
    );
  }

  void _onBlogRead(
    BlogReadEvent event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _readBlogUsecase(
      NoParams(),
    );

    response.fold(
      (l) => emit(BlogFailure(l.message)),
      (blogs) => emit(BlogReadSuccess(blogs)),
    );
  }

  /// Update Blog
  void _onBlogUpdate(
    BlogUpdateEvent event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _updateBlogUsecase(
      UpdateBlogParams(
        blogData: event.blogData,
        blogId: event.blogId,
        title: event.title,
        content: event.content,
        topics: event.topics,
        imageUrl: event.imageUrl,
      ),
    );

    response.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUpdateSuccess()),
    );
  }

  ///

  void _onBlogDelete(
    BlogDeleteEvent event,
    Emitter<BlogState> emit,
  ) async {
    final result = await _deleteBlogUsecase(
      DeleteBlogParams(blogId: event.blogId),
    );
    result.fold(
      (l) => emit(BlogFailure(l.message)),
      (blogs) => emit(BlogDeleteSuccess()),
    );
  }
}
