// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Go Deeper';

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
  String get updateAvailableDialogContent =>
      'A new version of the app is available. Would you like to download it now?';

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
  String get commentCannotBeEmpty => 'Comment cannot be empty.';

  @override
  String get loadArticleFailedRetry => 'Load article failed, tap to retry.';

  @override
  String get suggestionNoMore => 'No more suggestions.';

  @override
  String get suggestionLoginRequired => 'Please log in to view more.';

  @override
  String get noArticlesFound => 'No articles found.';

  @override
  String get noMoreArticles => 'No more articles.';

  @override
  String get articleDeletedSuccessfully => 'Article deleted successfully.';

  @override
  String get articleUpdatedSuccessfully => 'Article updated successfully.';

  @override
  String get articleCreatedSuccessfully => 'Article created successfully.';

  @override
  String articleSaveFailed(Object error) {
    return 'Failed to save article: $error';
  }

  @override
  String get titleCannotBeEmpty => 'Title cannot be empty.';

  @override
  String get contentCannotBeEmpty => 'Content cannot be empty.';

  @override
  String articleByAuthor(Object authorName) {
    return 'By $authorName';
  }

  @override
  String get articleByUnknownAuthor => 'By Unknown Author';

  @override
  String get agentTitle => 'AI Assistant';

  @override
  String get agentClearChatTooltip => 'Clear conversation';

  @override
  String get agentEmptyTitle => 'How can I help?';

  @override
  String get agentEmptySubtitle =>
      'I can help you write, edit articles, or draft comments.';

  @override
  String get agentInputHint => 'Type a message...';

  @override
  String get agentToolCalling => 'Calling tool...';

  @override
  String agentToolCallingTitle(Object toolName) {
    return 'Calling tool: $toolName';
  }

  @override
  String agentToolCompletedTitle(Object toolName) {
    return '$toolName completed';
  }

  @override
  String agentError(Object error) {
    return 'Something went wrong: $error';
  }

  @override
  String get agentMaxRoundsReached =>
      '[Agent reached the maximum tool-calling rounds]';

  @override
  String get agentSystemPromptLine1 =>
      'You are an intelligent assistant that helps users write articles, edit articles, and post comments.';

  @override
  String get agentSystemPromptLine2 =>
      'When the user asks for these actions, call the appropriate tools.';

  @override
  String get agentSystemPromptLine3 =>
      'When no tool is needed, reply directly in plain text.';

  @override
  String get agentContextHeader =>
      'Here is the context of what the user is currently working on:';

  @override
  String agentContextCurrentArticle(Object id) {
    return 'Currently viewing article (ID: $id)';
  }

  @override
  String agentContextEditingArticle(Object id) {
    return 'Currently editing article (ID: $id)';
  }

  @override
  String get agentContextCreatingArticle => 'Currently writing a new article';

  @override
  String agentContextTitleLine(Object value) {
    return 'Title: $value';
  }

  @override
  String agentContextSummaryLine(Object value) {
    return 'Summary: $value';
  }

  @override
  String agentContextContentLine(Object value) {
    return 'Content: $value';
  }

  @override
  String agentContextCommentChainLine(Object value) {
    return 'Current comment chain: $value';
  }

  @override
  String agentContextCommentEntry(Object content, Object userName) {
    return '[$userName] said: $content';
  }

  @override
  String get toolDraftArticleDescription =>
      'Generate an article draft and fill it into the editor for user review before publishing.';

  @override
  String get toolDraftArticleTitleParam => 'Article title';

  @override
  String get toolDraftArticleContentParam =>
      'Article body content in Markdown format';

  @override
  String get toolDraftArticleSummaryParam => 'Article summary (optional)';

  @override
  String get toolDraftEditArticleDescription =>
      'Generate revised article content and fill it into the editor for user review before saving.';

  @override
  String get toolDraftEditArticleTitleParam =>
      'Updated title (optional; keep the current title if omitted)';

  @override
  String get toolDraftEditArticleContentParam =>
      'Updated body content (optional; keep the current body if omitted)';

  @override
  String get toolDraftEditArticleSummaryParam =>
      'Updated summary (optional; keep the current summary if omitted)';

  @override
  String get toolDraftCommentDescription =>
      'Generate a comment draft and fill it into the input box for user review before posting.';

  @override
  String get toolDraftCommentContentParam => 'Comment content';

  @override
  String get toolChangeLocalizationDescription =>
      'Switch the user interface language.';

  @override
  String get toolChangeLocalizationLanguageCodeParam =>
      'Target ISO 639-1 language code. Currently supports \"en\" and \"zh\". Use \"follow_system\" to follow system language.';

  @override
  String toolDraftArticleFilled(Object title) {
    return 'The article draft has been filled into the editor. Title: $title. Please let the user review it before publishing.';
  }

  @override
  String toolDraftArticleUnsupported(Object title) {
    return 'The draft was generated, but the current page does not support filling articles. Title: $title';
  }

  @override
  String get toolDraftEditArticleFilled =>
      'The revised content has been filled into the editor. Please let the user review it before saving.';

  @override
  String get toolDraftEditArticleUnsupported =>
      'The draft was generated, but the current page does not support filling articles.';

  @override
  String toolDraftCommentFilled(Object content) {
    return 'The comment draft has been filled into the input box: \"$content\". Please let the user review it before posting.';
  }

  @override
  String toolDraftCommentUnsupported(Object content) {
    return 'The draft was generated, but the current page does not support filling comments. Content: $content';
  }

  @override
  String get toolLanguageFollowSystem =>
      'The language has been switched to follow the system.';

  @override
  String toolLanguageChanged(Object code) {
    return 'The interface language has been changed to $code.';
  }

  @override
  String toolLanguageUnsupported(Object code) {
    return 'Unsupported language code: $code';
  }

  @override
  String toolUnknown(Object name) {
    return 'Unknown tool: $name';
  }

  @override
  String toolExecutionFailed(Object error) {
    return 'Tool execution failed: $error';
  }

  @override
  String couldNotLaunchUrl(Object url) {
    return 'Could not launch $url';
  }

  @override
  String get passwordMinLength =>
      'Password must be at least 6 characters long.';

  @override
  String get signUpSuccess => 'Signed up successfully.';

  @override
  String get passwordLettersNumbers =>
      'Password must include both letters and numbers.';

  @override
  String get emailAlreadyRegistered => 'This email is already registered.';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get emailPasswordRequired => 'Email and password cannot be empty.';

  @override
  String get signInSuccess => 'Signed in successfully.';

  @override
  String get signInFailed => 'Sign in failed.';

  @override
  String get invalidLoginCredentials => 'Email or password is incorrect.';

  @override
  String get signOutSuccess => 'Signed out successfully.';

  @override
  String get displayNameUnchanged => 'Display name is unchanged.';

  @override
  String get displayNameUpdated => 'Display name updated.';

  @override
  String secondsAgo(Object seconds) {
    return '$seconds seconds ago';
  }

  @override
  String minutesAgo(Object minutes) {
    return '$minutes minutes ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours hours ago';
  }

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String get justNow => 'Just now';

  @override
  String onDate(Object day, Object month, Object year) {
    return '$month-$day-$year';
  }

  @override
  String get userProfile => 'User Profile';

  @override
  String currentVersion(Object version) {
    return 'Version: $version';
  }

  @override
  String get testPageTitle => 'Test Page';

  @override
  String get noEmail => 'No Email';

  @override
  String get changeDisplayName => 'Change display name';

  @override
  String get getArticles => 'Get articles';

  @override
  String get askAi => 'Ask AI';

  @override
  String get showToast => 'Show toast';

  @override
  String get sampleToast => '111';

  @override
  String get testUser => 'Test User';

  @override
  String get replyUser => 'Reply User';

  @override
  String get testPageSampleComment =>
      'Below is the minimal-change approach: add a profiles field to ArticleFeed and use readValue to map profiles.username to authorName, then regenerate feeditem.g.dart.';

  @override
  String get testPageSampleReply => 'This is a reply.';
}
