import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../l10n/app_localizations.dart';

String howLongTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  final l10n = Get.context != null ? AppLocalizations.of(Get.context!) : null;
  if (l10n == null) {
    return '';
  }

  if (difference.inSeconds < 60) {
    return l10n.justNow;
  } else if (difference.inMinutes < 60) {
    return l10n.minutesAgo(difference.inMinutes);
  } else if (difference.inHours < 24) {
    return l10n.hoursAgo(difference.inHours);
  } else if (difference.inDays < 3) {
    return l10n.daysAgo(difference.inDays);
  } else {
    return l10n.onDate(dateTime.day, dateTime.month, dateTime.year);
  }
}