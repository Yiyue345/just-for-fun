import 'package:get/get.dart';
import 'package:go_deeper/data/model/feeditem.dart';

class FeedItemController extends GetxController {
  final feedItems = <FeedItem>[].obs;

  final loading = false.obs;
  final page = 1.obs;

  Future<void> loadFeeds({bool refresh = false}) async {

  }
}