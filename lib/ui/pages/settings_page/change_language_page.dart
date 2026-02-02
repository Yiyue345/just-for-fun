import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  var currentLocale = Get.deviceLocale.obs;
  var isFollowSystem = true.obs;
  var supportedLocales = AppLocalizations.supportedLocales;

  @override
  void onInit() {
    super.onInit();
    _roadSavedLanguage();
  }

  void _roadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language');
    final followSystem = prefs.getBool('follow_system') ?? true;

    isFollowSystem.value = followSystem;

    if (followSystem) {
      currentLocale.value = Get.deviceLocale!;
    }
    else if (savedLanguage != null) {
      Locale locale;
      if (savedLanguage.contains('_')) {
        final parts = savedLanguage.split('_');
        locale = Locale(parts[0], parts[1]);
      } else {
        locale = Locale(savedLanguage);
      }
      currentLocale.value = locale;
      Get.updateLocale(locale);
    }
  }

  void changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    Locale locale;
    if (languageCode.contains('_')) {
      var parts = languageCode.split('_');
      locale = Locale(parts[0], parts[1]);
    } else {
      locale = Locale(languageCode);
    }
    Get.updateLocale(locale);
    currentLocale.value = locale;
    isFollowSystem.value = false;

    await prefs.setString('language', languageCode);
    await prefs.setBool('follow_system', false);
  }

  void followSystemLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    var locale = Get.deviceLocale!;
    Get.updateLocale(locale);
    currentLocale.value = locale;
    isFollowSystem.value = true;

    await prefs.setBool('follow_system', true);
    await prefs.remove('language');
  }
}

class ChangeLanguagePage extends StatelessWidget {
  final languageController = Get.put(LanguageController());

  String _languageLabel(AppLocalizations l10n, Locale locale) {
    final lc = locale.languageCode.toLowerCase();
    final cc = locale.countryCode;

    if (lc == 'en') return l10n.language_en;
    if (lc == 'fr') return l10n.language_fr;
    if (lc == 'de') return l10n.language_de;
    if (lc == 'zh' && (cc == 'CN' || cc == null || cc.isEmpty)) {
      return l10n.language_zh_CN;
    }

    return locale.toLanguageTag();
  }

  String _localeToSavedCode(Locale locale) {
    final cc = locale.countryCode;
    if (cc == null || cc.isEmpty) return locale.languageCode;
    return '${locale.languageCode}_$cc';
  }

  bool _isSameLocale(Locale a, Locale b) {
    return a.languageCode == b.languageCode &&
        (a.countryCode ?? '') == (b.countryCode ?? '');
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSubtitle),
      ),
      body: ListView.builder(
        itemCount: languageController.supportedLocales.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Obx(() => ListTile(
                title: Text(l10n.followSystemLanguage),
                trailing: languageController.isFollowSystem.value
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  languageController.followSystemLanguage();
                },
              ));
            }

            final locale = languageController.supportedLocales[index - 1];
            final label = _languageLabel(l10n, locale);

            return Obx(() {
              final isSelected = !languageController.isFollowSystem.value &&
                  _isSameLocale(languageController.currentLocale.value!, locale);
              return ListTile(
                title: Text(label),
                trailing: isSelected
                    ? Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                )
                    : null,
                onTap: () => languageController.changeLocale(_localeToSavedCode(locale)),
              );
            });
          }
      ),
    );
  }
}
