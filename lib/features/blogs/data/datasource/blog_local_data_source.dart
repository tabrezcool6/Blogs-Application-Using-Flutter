import 'package:blogs_app/features/blogs/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadBlogsLocally({required List<BlogModel> blogs});
  List<BlogModel> fetchBlogsLocally();
}

class BlogLocalDataSourceImplementation implements BlogLocalDataSource {
  Box box;
  BlogLocalDataSourceImplementation(this.box);

  @override
  List<BlogModel> fetchBlogsLocally() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (var i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });

    return blogs;
  }

  @override
  void uploadBlogsLocally({required List<BlogModel> blogs}) {
    box.clear();
    box.write(() {
      for (var i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
