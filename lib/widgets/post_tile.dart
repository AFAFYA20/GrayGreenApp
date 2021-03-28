import 'package:flutter/material.dart';
import 'package:graygreen/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
   // return Text("Post Tile");
    return GestureDetector(
     child: Image.network(post.mediaUrl),
    );
  }
}
