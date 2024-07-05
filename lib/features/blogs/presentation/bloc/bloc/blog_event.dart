part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploadEvent extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File imageUrl;
  final List<String> topics;

  BlogUploadEvent({
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
  });
}

final class BlogsFetchEvent extends BlogEvent {}

final class BlogDeleteEvent extends BlogEvent {
  final String blogId;
  BlogDeleteEvent({required this.blogId});
}
