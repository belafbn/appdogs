import 'dart:convert';

import 'package:http/http.dart';

import '../model/post.dart';

class ServiceHttp {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  Future<List<Post>> getPosts() async {
    Response res = await get(url);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();

      return posts;
      
    } else {
      throw "Não foi possível recuperar os dados";
    }
  }
}