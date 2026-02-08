import 'package:flutter/material.dart';
import 'package:go_deeper/data/model/comment.dart';

class CommentTile extends StatelessWidget {

  final Comment comment;

  CommentTile({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 0,),
          ListTile(
            title: Text(comment.userName),
            subtitle: Text(comment.content),
            trailing: IconButton(
                onPressed: () {
                  
                }, 
                icon: Icon(Icons.chat_bubble_outline)
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Row(
              children: [
                Text(comment.createdAt.toLocal().toString())
              ],
            ),
          ),
          Divider(height: 0,)
        ],
      ),
    );
  }
}