import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/network/user_auth.dart';
import 'package:go_deeper/core/network/user_controller.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/data/model/comment.dart';
import 'package:go_deeper/ui/pages/article_pages/article_controller.dart';
import 'package:go_deeper/ui/widgets/comment_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {

    // Get.put(CommentController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Obx(() {
        if (userController.isLoggedIn.value) {
          final testComment = Comment(
            id: 123,
            articleId: 222,
            userId: '123456',
            userName: '测试用户',
            content: '下面是最小改动方案：在 ArticleFeed 里增加 profiles 字段并用 readValue 把 profiles.username 映射到 authorName，然后重新生成 feeditem.g.dart。',
            createdAt: DateTime.now(),
          );
          final reply = Comment(
            id: 456,
            articleId: 222,
            userId: '654321',
            userName: '回复用户',
            content: '这是回复内容',
            createdAt: DateTime.now(),
            parentId: 123,
            parentUserName: '测试用户',
          );
          testComment.replies.add(reply);
          testComment.replies.add(reply);
          testComment.replies.add(reply);
          testComment.replies.add(reply);
          testComment.replies.add(reply);
          testComment.replies.add(reply);
          // 难道是 getx 的特性吗。。。不用 SizeBox.expand 就不能覆盖整个父组件的宽度
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(userController.user.value!.email ?? 'No Email'),
                SizedBox(height: 20),
                Text(getUserName() ?? ''),
                SizedBox(height: 20),
                Text(userController.user.value!.id),
                SizedBox(height: 20,),
                Text(userController.session.value?.expiresIn.toString() ?? ''),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      await setUserName('1112223333');
                    },
                    child: Text('Change display name')
                ),
                ElevatedButton(onPressed: () async {
                  await getArticles();
                },
                  child: Text('Get articles'),
                ),
                ElevatedButton(onPressed: () async {
                  signOut();
                },
                    child: Text('Sign out')
                ),
                SizedBox(height: 16,),
                CommentTile(
                    comment: testComment,
                  isTopLevelComment: true,
                )
              ],
            ),
          );
        }
        else {
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => showSignUpDialog(),
                    child: Text('Sign up')
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => showSignInDialog(),
                    child: Text('Sign in')
                ),
                ElevatedButton(onPressed: () {
                  Fluttertoast.showToast(msg: '111');
                }, child: Text('show toast'))
              ],
            ),
          );
        }

      }),
    );
  }

}