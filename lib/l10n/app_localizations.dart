import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Deeper'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutTitle;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutMessage;

  /// No description provided for @noDisplayName.
  ///
  /// In en, this message translates to:
  /// **'No display name'**
  String get noDisplayName;

  /// No description provided for @noLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get noLoggedIn;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @setDisplayNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Display Name'**
  String get setDisplayNameTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingUserSubtitle.
  ///
  /// In en, this message translates to:
  /// **'User settings and preferences'**
  String get settingUserSubtitle;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @checkingForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'An update is available!'**
  String get updateAvailable;

  /// No description provided for @noUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Your application is up to date.'**
  String get noUpdateAvailable;

  /// No description provided for @updateAvailableDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailableDialogTitle;

  /// No description provided for @updateAvailableDialogContent.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Would you like to download it now?'**
  String get updateAvailableDialogContent;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get languageSubtitle;

  /// No description provided for @followSystemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Follow System Language'**
  String get followSystemLanguage;

  /// Language and language code to represent it
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @language_fr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get language_fr;

  /// No description provided for @language_de.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get language_de;

  /// No description provided for @language_zh_CN.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get language_zh_CN;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @whoseArticles.
  ///
  /// In en, this message translates to:
  /// **'{who}\'s Articles'**
  String whoseArticles(Object who);

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @editArticle.
  ///
  /// In en, this message translates to:
  /// **'Edit Article'**
  String get editArticle;

  /// No description provided for @publicArticle.
  ///
  /// In en, this message translates to:
  /// **'Public Article'**
  String get publicArticle;

  /// No description provided for @discardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving will lost all changes.'**
  String get discardChangesMessage;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @deleteArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Article'**
  String get deleteArticleTitle;

  /// No description provided for @deleteArticleMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this article? This action cannot be undone.'**
  String get deleteArticleMessage;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get noComments;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your comment here...'**
  String get commentHint;

  /// No description provided for @postCommentTo.
  ///
  /// In en, this message translates to:
  /// **'Post comment to {entityName}'**
  String postCommentTo(Object entityName);

  /// No description provided for @replyTo.
  ///
  /// In en, this message translates to:
  /// **'Reply to @{userName}'**
  String replyTo(Object userName);

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to @{userName}'**
  String replyingTo(Object userName);

  /// No description provided for @commentPostedToast.
  ///
  /// In en, this message translates to:
  /// **'Comment posted'**
  String get commentPostedToast;

  /// No description provided for @commentCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Comment cannot be empty.'**
  String get commentCannotBeEmpty;

  /// No description provided for @loadArticleFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Load article failed, tap to retry.'**
  String get loadArticleFailedRetry;

  /// No description provided for @suggestionNoMore.
  ///
  /// In en, this message translates to:
  /// **'No more suggestions.'**
  String get suggestionNoMore;

  /// No description provided for @suggestionLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view more.'**
  String get suggestionLoginRequired;

  /// No description provided for @noArticlesFound.
  ///
  /// In en, this message translates to:
  /// **'No articles found.'**
  String get noArticlesFound;

  /// No description provided for @noMoreArticles.
  ///
  /// In en, this message translates to:
  /// **'No more articles.'**
  String get noMoreArticles;

  /// No description provided for @articleDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Article deleted successfully.'**
  String get articleDeletedSuccessfully;

  /// No description provided for @articleUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Article updated successfully.'**
  String get articleUpdatedSuccessfully;

  /// No description provided for @articleCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Article created successfully.'**
  String get articleCreatedSuccessfully;

  /// No description provided for @articleSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save article: {error}'**
  String articleSaveFailed(Object error);

  /// No description provided for @titleCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title cannot be empty.'**
  String get titleCannotBeEmpty;

  /// No description provided for @contentCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Content cannot be empty.'**
  String get contentCannotBeEmpty;

  /// No description provided for @articleByAuthor.
  ///
  /// In en, this message translates to:
  /// **'By {authorName}'**
  String articleByAuthor(Object authorName);

  /// No description provided for @articleByUnknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'By Unknown Author'**
  String get articleByUnknownAuthor;

  /// No description provided for @agentTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get agentTitle;

  /// No description provided for @agentClearChatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear conversation'**
  String get agentClearChatTooltip;

  /// No description provided for @agentEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'How can I help?'**
  String get agentEmptyTitle;

  /// No description provided for @agentEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'I can help you write, edit articles, or draft comments.'**
  String get agentEmptySubtitle;

  /// No description provided for @agentInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get agentInputHint;

  /// No description provided for @agentToolCalling.
  ///
  /// In en, this message translates to:
  /// **'Calling tool...'**
  String get agentToolCalling;

  /// No description provided for @agentToolCallingTitle.
  ///
  /// In en, this message translates to:
  /// **'Calling tool: {toolName}'**
  String agentToolCallingTitle(Object toolName);

  /// No description provided for @agentToolCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'{toolName} completed'**
  String agentToolCompletedTitle(Object toolName);

  /// No description provided for @agentError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String agentError(Object error);

  /// No description provided for @agentMaxRoundsReached.
  ///
  /// In en, this message translates to:
  /// **'[Agent reached the maximum tool-calling rounds]'**
  String get agentMaxRoundsReached;

  /// No description provided for @agentSystemPromptLine1.
  ///
  /// In en, this message translates to:
  /// **'You are an intelligent assistant that helps users write articles, edit articles, and post comments.'**
  String get agentSystemPromptLine1;

  /// No description provided for @agentSystemPromptLine2.
  ///
  /// In en, this message translates to:
  /// **'When the user asks for these actions, call the appropriate tools.'**
  String get agentSystemPromptLine2;

  /// No description provided for @agentSystemPromptLine3.
  ///
  /// In en, this message translates to:
  /// **'When no tool is needed, reply directly in plain text.'**
  String get agentSystemPromptLine3;

  /// No description provided for @agentContextHeader.
  ///
  /// In en, this message translates to:
  /// **'Here is the context of what the user is currently working on:'**
  String get agentContextHeader;

  /// No description provided for @agentContextCurrentArticle.
  ///
  /// In en, this message translates to:
  /// **'Currently viewing article (ID: {id})'**
  String agentContextCurrentArticle(Object id);

  /// No description provided for @agentContextEditingArticle.
  ///
  /// In en, this message translates to:
  /// **'Currently editing article (ID: {id})'**
  String agentContextEditingArticle(Object id);

  /// No description provided for @agentContextCreatingArticle.
  ///
  /// In en, this message translates to:
  /// **'Currently writing a new article'**
  String get agentContextCreatingArticle;

  /// No description provided for @agentContextTitleLine.
  ///
  /// In en, this message translates to:
  /// **'Title: {value}'**
  String agentContextTitleLine(Object value);

  /// No description provided for @agentContextSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'Summary: {value}'**
  String agentContextSummaryLine(Object value);

  /// No description provided for @agentContextContentLine.
  ///
  /// In en, this message translates to:
  /// **'Content: {value}'**
  String agentContextContentLine(Object value);

  /// No description provided for @agentContextCommentChainLine.
  ///
  /// In en, this message translates to:
  /// **'Current comment chain: {value}'**
  String agentContextCommentChainLine(Object value);

  /// No description provided for @agentContextCommentEntry.
  ///
  /// In en, this message translates to:
  /// **'[{userName}] said: {content}'**
  String agentContextCommentEntry(Object content, Object userName);

  /// No description provided for @toolDraftArticleDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate an article draft and fill it into the editor for user review before publishing.'**
  String get toolDraftArticleDescription;

  /// No description provided for @toolDraftArticleTitleParam.
  ///
  /// In en, this message translates to:
  /// **'Article title'**
  String get toolDraftArticleTitleParam;

  /// No description provided for @toolDraftArticleContentParam.
  ///
  /// In en, this message translates to:
  /// **'Article body content in Markdown format'**
  String get toolDraftArticleContentParam;

  /// No description provided for @toolDraftArticleSummaryParam.
  ///
  /// In en, this message translates to:
  /// **'Article summary (optional)'**
  String get toolDraftArticleSummaryParam;

  /// No description provided for @toolDraftEditArticleDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate revised article content and fill it into the editor for user review before saving.'**
  String get toolDraftEditArticleDescription;

  /// No description provided for @toolDraftEditArticleTitleParam.
  ///
  /// In en, this message translates to:
  /// **'Updated title (optional; keep the current title if omitted)'**
  String get toolDraftEditArticleTitleParam;

  /// No description provided for @toolDraftEditArticleContentParam.
  ///
  /// In en, this message translates to:
  /// **'Updated body content (optional; keep the current body if omitted)'**
  String get toolDraftEditArticleContentParam;

  /// No description provided for @toolDraftEditArticleSummaryParam.
  ///
  /// In en, this message translates to:
  /// **'Updated summary (optional; keep the current summary if omitted)'**
  String get toolDraftEditArticleSummaryParam;

  /// No description provided for @toolDraftCommentDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate a comment draft and fill it into the input box for user review before posting.'**
  String get toolDraftCommentDescription;

  /// No description provided for @toolDraftCommentContentParam.
  ///
  /// In en, this message translates to:
  /// **'Comment content'**
  String get toolDraftCommentContentParam;

  /// No description provided for @toolChangeLocalizationDescription.
  ///
  /// In en, this message translates to:
  /// **'Switch the user interface language.'**
  String get toolChangeLocalizationDescription;

  /// No description provided for @toolChangeLocalizationLanguageCodeParam.
  ///
  /// In en, this message translates to:
  /// **'Target ISO 639-1 language code. Currently supports \"en\" and \"zh\". Use \"follow_system\" to follow system language.'**
  String get toolChangeLocalizationLanguageCodeParam;

  /// No description provided for @toolDraftArticleFilled.
  ///
  /// In en, this message translates to:
  /// **'The article draft has been filled into the editor. Title: {title}. Please let the user review it before publishing.'**
  String toolDraftArticleFilled(Object title);

  /// No description provided for @toolDraftArticleUnsupported.
  ///
  /// In en, this message translates to:
  /// **'The draft was generated, but the current page does not support filling articles. Title: {title}'**
  String toolDraftArticleUnsupported(Object title);

  /// No description provided for @toolDraftEditArticleFilled.
  ///
  /// In en, this message translates to:
  /// **'The revised content has been filled into the editor. Please let the user review it before saving.'**
  String get toolDraftEditArticleFilled;

  /// No description provided for @toolDraftEditArticleUnsupported.
  ///
  /// In en, this message translates to:
  /// **'The draft was generated, but the current page does not support filling articles.'**
  String get toolDraftEditArticleUnsupported;

  /// No description provided for @toolDraftCommentFilled.
  ///
  /// In en, this message translates to:
  /// **'The comment draft has been filled into the input box: \"{content}\". Please let the user review it before posting.'**
  String toolDraftCommentFilled(Object content);

  /// No description provided for @toolDraftCommentUnsupported.
  ///
  /// In en, this message translates to:
  /// **'The draft was generated, but the current page does not support filling comments. Content: {content}'**
  String toolDraftCommentUnsupported(Object content);

  /// No description provided for @toolLanguageFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'The language has been switched to follow the system.'**
  String get toolLanguageFollowSystem;

  /// No description provided for @toolLanguageChanged.
  ///
  /// In en, this message translates to:
  /// **'The interface language has been changed to {code}.'**
  String toolLanguageChanged(Object code);

  /// No description provided for @toolLanguageUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Unsupported language code: {code}'**
  String toolLanguageUnsupported(Object code);

  /// No description provided for @toolUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown tool: {name}'**
  String toolUnknown(Object name);

  /// No description provided for @toolExecutionFailed.
  ///
  /// In en, this message translates to:
  /// **'Tool execution failed: {error}'**
  String toolExecutionFailed(Object error);

  /// No description provided for @couldNotLaunchUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String couldNotLaunchUrl(Object url);

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get passwordMinLength;

  /// No description provided for @signUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed up successfully.'**
  String get signUpSuccess;

  /// No description provided for @passwordLettersNumbers.
  ///
  /// In en, this message translates to:
  /// **'Password must include both letters and numbers.'**
  String get passwordLettersNumbers;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyRegistered;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @emailPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password cannot be empty.'**
  String get emailPasswordRequired;

  /// No description provided for @signInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully.'**
  String get signInSuccess;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed.'**
  String get signInFailed;

  /// No description provided for @invalidLoginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get invalidLoginCredentials;

  /// No description provided for @signOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed out successfully.'**
  String get signOutSuccess;

  /// No description provided for @displayNameUnchanged.
  ///
  /// In en, this message translates to:
  /// **'Display name is unchanged.'**
  String get displayNameUnchanged;

  /// No description provided for @displayNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Display name updated.'**
  String get displayNameUpdated;

  /// No description provided for @secondsAgo.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds ago'**
  String secondsAgo(Object seconds);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(Object hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(Object days);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @onDate.
  ///
  /// In en, this message translates to:
  /// **'{month}-{day}-{year}'**
  String onDate(Object day, Object month, Object year);

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String currentVersion(Object version);

  /// No description provided for @testPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Page'**
  String get testPageTitle;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No Email'**
  String get noEmail;

  /// No description provided for @changeDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Change display name'**
  String get changeDisplayName;

  /// No description provided for @getArticles.
  ///
  /// In en, this message translates to:
  /// **'Get articles'**
  String get getArticles;

  /// No description provided for @askAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get askAi;

  /// No description provided for @showToast.
  ///
  /// In en, this message translates to:
  /// **'Show toast'**
  String get showToast;

  /// No description provided for @sampleToast.
  ///
  /// In en, this message translates to:
  /// **'111'**
  String get sampleToast;

  /// No description provided for @testUser.
  ///
  /// In en, this message translates to:
  /// **'Test User'**
  String get testUser;

  /// No description provided for @replyUser.
  ///
  /// In en, this message translates to:
  /// **'Reply User'**
  String get replyUser;

  /// No description provided for @testPageSampleComment.
  ///
  /// In en, this message translates to:
  /// **'Below is the minimal-change approach: add a profiles field to ArticleFeed and use readValue to map profiles.username to authorName, then regenerate feeditem.g.dart.'**
  String get testPageSampleComment;

  /// No description provided for @testPageSampleReply.
  ///
  /// In en, this message translates to:
  /// **'This is a reply.'**
  String get testPageSampleReply;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
