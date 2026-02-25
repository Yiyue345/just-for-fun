// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Application';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get user => 'User';

  @override
  String get displayName => 'Display Name';

  @override
  String get email => 'Email';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutTitle => 'Sign Out';

  @override
  String get signOutMessage => 'Are you sure you want to sign out?';

  @override
  String get noDisplayName => 'No display name';

  @override
  String get noLoggedIn => 'Not logged in';

  @override
  String get set => 'Set';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get search => 'Search';

  @override
  String get loading => 'Loading...';

  @override
  String get download => 'Download';

  @override
  String get post => 'Post';

  @override
  String get setDisplayNameTitle => 'Set Display Name';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingUserSubtitle => 'User settings and preferences';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get checkingForUpdates => 'Checking for updates...';

  @override
  String get updateAvailable => 'An update is available!';

  @override
  String get noUpdateAvailable => 'Your application is up to date.';

  @override
  String get updateAvailableDialogTitle => 'Update Available';

  @override
  String get about => 'About';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Change app language';

  @override
  String get followSystemLanguage => 'Follow System Language';

  @override
  String get language_en => 'English';

  @override
  String get language_fr => 'French';

  @override
  String get language_de => 'German';

  @override
  String get language_zh_CN => 'Simplified Chinese';

  @override
  String get articles => 'Articles';

  @override
  String whoseArticles(Object who) {
    return '$who\'s Articles';
  }

  @override
  String get title => 'Title';

  @override
  String get summary => 'Summary';

  @override
  String get content => 'Content';

  @override
  String get editArticle => 'Edit Article';

  @override
  String get publicArticle => 'Public Article';

  @override
  String get discardChangesTitle => 'Discard Changes?';

  @override
  String get discardChangesMessage =>
      'Leave without saving will lost all changes.';

  @override
  String get discard => 'Discard';

  @override
  String get deleteArticleTitle => 'Delete Article';

  @override
  String get deleteArticleMessage =>
      'Are you sure you want to delete this article? This action cannot be undone.';

  @override
  String get comment => 'Comment';

  @override
  String get comments => 'Comments';

  @override
  String get noComments => 'No comments yet.';

  @override
  String get commentHint => 'Enter your comment here...';

  @override
  String postCommentTo(Object entityName) {
    return 'Post comment to $entityName';
  }

  @override
  String replyTo(Object userName) {
    return 'Reply to @$userName';
  }

  @override
  String replyingTo(Object userName) {
    return 'Replying to @$userName';
  }

  @override
  String get commentPostedToast => 'Comment posted';

  @override
  String get userProfile => 'User Profile';

  @override
  String currentVersion(Object version) {
    return 'Version: $version';
  }
}
