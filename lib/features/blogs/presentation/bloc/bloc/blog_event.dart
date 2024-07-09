part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogCreateEvent extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File imageUrl;
  final List<String> topics;

  BlogCreateEvent({
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
  });
}

final class BlogReadEvent extends BlogEvent {}

// Event to update the existing blog, since all paramneters are not mandatory they are nullable
final class BlogUpdateEvent extends BlogEvent {
  final String blogId;
  final Blog blogData;
  String? title;
  String? content;
  File? imageUrl;
  List<String>? topics;

  BlogUpdateEvent({
    required this.blogData,
    required this.blogId,
    this.title,
    this.content,
    this.imageUrl,
    this.topics,
  });
}

final class BlogDeleteEvent extends BlogEvent {
  final String blogId;
  BlogDeleteEvent({required this.blogId});
}
