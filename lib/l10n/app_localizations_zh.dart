// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'My Application';

  @override
  String get home => '主页';

  @override
  String get settings => '设置';

  @override
  String get profile => '个人资料';

  @override
  String get logout => '退出';

  @override
  String get user => '用户';

  @override
  String get displayName => '用户名称';

  @override
  String get email => '电子邮件';

  @override
  String get emailAddress => '电子邮件地址';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get signIn => '登录';

  @override
  String get login => '登录';

  @override
  String get signup => '注册';

  @override
  String get signOut => '退出';

  @override
  String get signOutTitle => '退出登录';

  @override
  String get signOutMessage => '您确定要退出登录吗？';

  @override
  String get noDisplayName => '无用户名';

  @override
  String get noLoggedIn => '未登录';

  @override
  String get set => '设定';

  @override
  String get cancel => '取消';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get search => '搜索';

  @override
  String get loading => '加载中...';

  @override
  String get download => '下载';

  @override
  String get post => '发布';

  @override
  String get setDisplayNameTitle => '设置用户名';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingUserSubtitle => '用户设置和偏好';

  @override
  String get checkForUpdates => '检查更新';

  @override
  String get checkingForUpdates => '正在检查更新...';

  @override
  String get updateAvailable => '发现新版本！';

  @override
  String get noUpdateAvailable => '您的应用已是最新版本。';

  @override
  String get updateAvailableDialogTitle => '发现新版本';

  @override
  String get languageTitle => '语言';

  @override
  String get languageSubtitle => '更改应用语言';

  @override
  String get followSystemLanguage => '跟随系统';

  @override
  String get language_en => '英语';

  @override
  String get language_fr => '法语';

  @override
  String get language_de => '德语';

  @override
  String get language_zh_CN => '简体中文';

  @override
  String get articles => '文章';

  @override
  String whoseArticles(Object who) {
    return '$who的文章';
  }

  @override
  String get title => '标题';

  @override
  String get summary => '摘要';

  @override
  String get content => '内容';

  @override
  String get editArticle => '编辑文章';

  @override
  String get publicArticle => '公开文章';

  @override
  String get discardChangesTitle => '是否放弃更改？';

  @override
  String get discardChangesMessage => '退出将丢失所有更改。您确定要放弃更改吗？';

  @override
  String get discard => '放弃';

  @override
  String get deleteArticleTitle => '删除文章';

  @override
  String get deleteArticleMessage => '您确定要删除此文章吗？这个操作无法撤销。';

  @override
  String get commentHint => '在此输入评论内容...';

  @override
  String postCommentTo(Object entityName) {
    return '向$entityName的文章评论';
  }

  @override
  String replyTo(Object userName) {
    return '回复$userName';
  }

  @override
  String get userProfile => '用户资料';
}
