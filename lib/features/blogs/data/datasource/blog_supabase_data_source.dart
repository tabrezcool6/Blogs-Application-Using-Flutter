import 'dart:io';

import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/features/blogs/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogSupabaseDataSource {
  // Abstract method to upload blog to database
  Future<BlogModel> uploadBlog(BlogModel blogModel);

  // abstract method to upload image to database
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blogModel,
  });

  // abstract meethod to fetch blogs from database
  Future<List<BlogModel>> fetchBlogs();

  // abstract meethod to Update blogs from database
  Future<BlogModel> updateBlog({String? title, required String blogId});

  Future<void> deleteBlog({required String blogId});
}

// concrete Implementatiion of abstract
class BlogSupabaseDataSourceImplementation extends BlogSupabaseDataSource {
  SupabaseClient supabaseClient;
  BlogSupabaseDataSourceImplementation(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async {
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

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blogModel,
  }) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .upload(blogModel.id, image);
      return supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(blogModel.id);
    } on StorageException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> fetchBlogs() async {
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

  @override
  Future<BlogModel> updateBlog({
    String? title,
    required String blogId,
  }) async {
    try {
      print('///// id $blogId');
      print('///// title $title');

      final blogData = await supabaseClient
          .from('blogs')
          .update({'title': title})
          .eq('id', blogId)
          .select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
