// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Go Deeper';

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
  String get updateAvailableDialogContent => '发现了应用新版本，现在要去下载吗？';

  @override
  String get about => '关于';

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
  String get comment => '评论';

  @override
  String get comments => '评论';

  @override
  String get noComments => '还没有评论';

  @override
  String get commentHint => '在此输入评论内容...';

  @override
  String postCommentTo(Object entityName) {
    return '向$entityName的文章评论';
  }

  @override
  String replyTo(Object userName) {
    return '回复@$userName';
  }

  @override
  String replyingTo(Object userName) {
    return '回复@$userName';
  }

  @override
  String get commentPostedToast => '评论已发布';

  @override
  String get commentCannotBeEmpty => '评论不能为空！';

  @override
  String get loadArticleFailedRetry => '加载文章失败，点击重试。';

  @override
  String get suggestionNoMore => '没有更多推荐了。';

  @override
  String get suggestionLoginRequired => '请先登录以查看更多内容。';

  @override
  String get noArticlesFound => '没有找到文章。';

  @override
  String get noMoreArticles => '没有更多文章了。';

  @override
  String get articleDeletedSuccessfully => '文章已删除。';

  @override
  String get articleUpdatedSuccessfully => '文章更新成功。';

  @override
  String get articleCreatedSuccessfully => '文章创建成功。';

  @override
  String articleSaveFailed(Object error) {
    return '保存文章失败：$error';
  }

  @override
  String get titleCannotBeEmpty => '标题不能为空。';

  @override
  String get contentCannotBeEmpty => '正文不能为空。';

  @override
  String articleByAuthor(Object authorName) {
    return '作者：$authorName';
  }

  @override
  String get articleByUnknownAuthor => '作者未知';

  @override
  String get agentTitle => 'AI 助手';

  @override
  String get agentClearChatTooltip => '清空对话';

  @override
  String get agentEmptyTitle => '有什么可以帮你的？';

  @override
  String get agentEmptySubtitle => '我可以帮你撰写、修改文章或起草评论。';

  @override
  String get agentInputHint => '输入消息...';

  @override
  String get agentToolCalling => '正在调用工具...';

  @override
  String agentToolCallingTitle(Object toolName) {
    return '调用工具：$toolName';
  }

  @override
  String agentToolCompletedTitle(Object toolName) {
    return '$toolName 执行完成';
  }

  @override
  String agentError(Object error) {
    return '出错了：$error';
  }

  @override
  String get agentMaxRoundsReached => '[Agent 达到最大工具调用轮次限制]';

  @override
  String get agentSystemPromptLine1 => '你是一个智能助手，可以帮助用户撰写文章、修改文章、发布评论。';

  @override
  String get agentSystemPromptLine2 => '当用户要求你执行这些操作时，请调用对应的工具。';

  @override
  String get agentSystemPromptLine3 => '当不需要调用工具时，直接用纯文本回复用户。';

  @override
  String get agentContextHeader => '以下是用户当前正在操作的内容上下文：';

  @override
  String agentContextCurrentArticle(Object id) {
    return '当前正在查看文章（ID: $id）';
  }

  @override
  String agentContextEditingArticle(Object id) {
    return '当前正在编辑文章（ID: $id）';
  }

  @override
  String get agentContextCreatingArticle => '当前正在撰写新文章';

  @override
  String agentContextTitleLine(Object value) {
    return '标题: $value';
  }

  @override
  String agentContextSummaryLine(Object value) {
    return '摘要: $value';
  }

  @override
  String agentContextContentLine(Object value) {
    return '正文: $value';
  }

  @override
  String agentContextCommentChainLine(Object value) {
    return '当前评论链：$value';
  }

  @override
  String agentContextCommentEntry(Object content, Object userName) {
    return '【$userName】说：$content';
  }

  @override
  String get toolDraftArticleDescription => '生成文章草稿并填充到编辑器中，供用户审核后决定是否发布。';

  @override
  String get toolDraftArticleTitleParam => '文章标题';

  @override
  String get toolDraftArticleContentParam => '文章正文内容（使用 Markdown 格式）';

  @override
  String get toolDraftArticleSummaryParam => '文章摘要（可选）';

  @override
  String get toolDraftEditArticleDescription =>
      '生成修改后的文章内容并填充到编辑器中，供用户审核后决定是否保存。';

  @override
  String get toolDraftEditArticleTitleParam => '修改后的标题（可选，不提供则保持原标题）';

  @override
  String get toolDraftEditArticleContentParam => '修改后的正文（可选，不提供则保持原正文）';

  @override
  String get toolDraftEditArticleSummaryParam => '修改后的摘要（可选，不提供则保持原摘要）';

  @override
  String get toolDraftCommentDescription => '生成评论草稿并填充到评论输入框中，供用户审核后决定是否发布。';

  @override
  String get toolDraftCommentContentParam => '评论内容';

  @override
  String get toolChangeLocalizationDescription => '切换用户界面语言。';

  @override
  String get toolChangeLocalizationLanguageCodeParam =>
      '目标语言的 ISO 639-1 代码，目前支持 \"en\"、\"zh\"，若返回 \"follow_system\"，则切换为跟随系统。';

  @override
  String toolDraftArticleFilled(Object title) {
    return '已将文章草稿填充到编辑器，标题: $title。请用户审核后决定是否发布。';
  }

  @override
  String toolDraftArticleUnsupported(Object title) {
    return '草稿已生成，但当前页面不支持填充文章。标题: $title';
  }

  @override
  String get toolDraftEditArticleFilled => '已将修改后的内容填充到编辑器。请用户审核后决定是否保存。';

  @override
  String get toolDraftEditArticleUnsupported => '草稿已生成，但当前页面不支持填充文章。';

  @override
  String toolDraftCommentFilled(Object content) {
    return '已将评论草稿填充到输入框: \"$content\"。请用户审核后决定是否发布。';
  }

  @override
  String toolDraftCommentUnsupported(Object content) {
    return '草稿已生成，但当前页面不支持填充评论。内容: $content';
  }

  @override
  String get toolLanguageFollowSystem => '已将语言切换为跟随系统';

  @override
  String toolLanguageChanged(Object code) {
    return '已将界面语言切换为 $code';
  }

  @override
  String toolLanguageUnsupported(Object code) {
    return '不支持的语言代码: $code';
  }

  @override
  String toolUnknown(Object name) {
    return '未知工具: $name';
  }

  @override
  String toolExecutionFailed(Object error) {
    return '工具执行失败: $error';
  }

  @override
  String couldNotLaunchUrl(Object url) {
    return '无法打开链接：$url';
  }

  @override
  String get passwordMinLength => '密码长度至少需要 6 位。';

  @override
  String get signUpSuccess => '注册成功。';

  @override
  String get passwordLettersNumbers => '密码必须同时包含字母和数字。';

  @override
  String get emailAlreadyRegistered => '该邮箱已被注册。';

  @override
  String get unexpectedError => '发生了意外错误。';

  @override
  String get emailPasswordRequired => '邮箱和密码不能为空。';

  @override
  String get signInSuccess => '登录成功。';

  @override
  String get signInFailed => '登录失败。';

  @override
  String get invalidLoginCredentials => '邮箱或密码不正确。';

  @override
  String get signOutSuccess => '已退出登录。';

  @override
  String get displayNameUnchanged => '显示名称未发生变化。';

  @override
  String get displayNameUpdated => '显示名称已更新。';

  @override
  String secondsAgo(Object seconds) {
    return '$seconds秒前';
  }

  @override
  String minutesAgo(Object minutes) {
    return '$minutes分钟前';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours小时前';
  }

  @override
  String daysAgo(Object days) {
    return '$days天前';
  }

  @override
  String get justNow => '刚刚';

  @override
  String onDate(Object day, Object month, Object year) {
    return '$year年$month月$day日';
  }

  @override
  String get userProfile => '用户资料';

  @override
  String currentVersion(Object version) {
    return '当前版本：$version';
  }

  @override
  String get testPageTitle => '测试页面';

  @override
  String get noEmail => '无邮箱';

  @override
  String get changeDisplayName => '修改显示名称';

  @override
  String get getArticles => '获取文章';

  @override
  String get askAi => '问 AI';

  @override
  String get showToast => '显示提示';

  @override
  String get sampleToast => '111';

  @override
  String get testUser => '测试用户';

  @override
  String get replyUser => '回复用户';

  @override
  String get testPageSampleComment =>
      '下面是最小改动方案：在 ArticleFeed 里增加 profiles 字段并用 readValue 把 profiles.username 映射到 authorName，然后重新生成 feeditem.g.dart。';

  @override
  String get testPageSampleReply => '这是回复内容';
}
