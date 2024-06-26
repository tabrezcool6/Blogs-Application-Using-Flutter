import 'dart:io';

import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/features/blogs/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogSupabaseDataSource {
  Future<BlogModel> uploadBlog(BlogModel blogModel);

  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blogModel,
  });

  Future<List<BlogModel>> fetchBlogs();
}

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
}
