import 'dart:io';

import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/features/blogs/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogSupabaseDataSource {
  // Abstract method to Create blog to database
  Future<BlogModel> createBlog(BlogModel blogModel);

  // abstract meethod to Read blog from database
  Future<List<BlogModel>> readBlog();

  // abstract meethod to Update blog from database
  Future<BlogModel> updateBlog({
    required String blogId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
  });

  // abstract meethod to Delete blog from database
  Future<void> deleteBlog({required String blogId});

  // abstract method to Upload image to database
  Future<String> uploadBlogImage({
    required File image,
    required String blogId,
  });

  // abstract method to Update image to database
  Future<String> updateBlogImage({
    required blogId,
    required File image,
  });
}

// concrete Implementatiion of abstract
class BlogSupabaseDataSourceImplementation extends BlogSupabaseDataSource {
  SupabaseClient supabaseClient;
  BlogSupabaseDataSourceImplementation(this.supabaseClient);

  /// concrete Implementatiion of Creating a Blog to upload it to Server
  @override
  Future<BlogModel> createBlog(BlogModel blogModel) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blogModel.toJson())
          .select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  /// concrete Implementatiion of Reading Blogs to display in thee application
  @override
  Future<List<BlogModel>> readBlog() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');

      // method to sort blogs based on blog created time
      // i.e, newly created blog will be displayed on the top of the list
      blogs.sort((a, b) =>
          (b["updated_at"] as String).compareTo(a["updated_at"] as String));

      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  /// concrete Implementatiion of Updating Blogs on the Server
  @override
  Future<BlogModel> updateBlog({
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    required String blogId,
  }) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .update({
            'title': title,
            'content': content,
            'topics': topics,
            'image_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', blogId)
          .select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  /// concrete Implementatiion of Deleting Blogs from the Server
  @override
  Future<void> deleteBlog({required String blogId}) async {
    try {
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  /// concrete Implementatiion of Uploading images to the Database
  @override
  Future<String> uploadBlogImage({
    required File image,
    required String blogId,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blogId, image);

      return supabaseClient.storage.from('blog_images').getPublicUrl(blogId);
    } on StorageException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  /// concrete Implementatiion of Updating images in the Database
  @override
  Future<String> updateBlogImage({required blogId, required File image}) async {
    try {
      await supabaseClient.storage.from('blog_images').update(
            blogId,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      return supabaseClient.storage.from('blog_images').getPublicUrl(blogId);
    } on StorageException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
