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

// Event to update the existing blog, since all paramneters are not mandatory they are nullable
final class BlogUpdateEvent extends BlogEvent {
  String? title;
  final String blogId;
  final Blog blogData;
  // String? content;
  // File? imageUrl;
  // List<String>? topics;

  BlogUpdateEvent({
    this.title,
    required this.blogId,
    required this.blogData,
    // this.content,
    // this.imageUrl,
    // this.topics,
  });
}
