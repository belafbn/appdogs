import 'package:flutter/material.dart';
import '../service/service_http.dart';

import '../model/post.dart';


class PostPage extends StatelessWidget {
  final ServiceHttp serviceHttp = ServiceHttp();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posts")),
      body: FutureBuilder(
        future: serviceHttp.getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            List<Post>? posts = snapshot.data;

            return ListView(
              children: posts!.map((Post post) => 
                ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.userId.toString()),
                )
              ).toList(),
            );
          } 

          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }

  
}