Package.describe({
	name: 'tagt:lib',
	version: '0.0.1',
	summary: 'TAGT libraries',
	git: ''
});

Npm.depends({
	'bad-words': '1.3.1',
	'localforage': '1.4.2',
	'bugsnag': '1.8.0',

	'handlebars':'4.0.5',
	'pinyin': '2.8.0'
});



Package.onUse(function(api) {
	api.use('rate-limit');
	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('accounts-base');
	api.use('coffeescript');
	api.use('ecmascript');
	api.use('random');
	api.use('check');
	api.use('tracker');
	api.use('ddp-rate-limiter');
	api.use('underscore');
	api.use('mongo');
	api.use('underscorestring:underscore.string');
	api.use('monbro:mongodb-mapreduce-aggregation@1.0.1');
	api.use('matb33:collection-hooks');
	api.use('service-configuration');
	api.use('check');
	api.use('tagt:i18n');
	api.use('tagt:streamer');
	api.use('tagt:version');
	api.use('tagt:logger');
	api.use('tagt:custom-oauth');

	api.use('templating', 'client');
	api.use('kadira:flow-router');

	api.addFiles('lib/core.coffee');

	// DEBUGGER
	api.addFiles('server/lib/debug.js', 'server');

	// COMMON LIB
	api.addFiles('lib/settings.coffee');
	api.addFiles('lib/configLogger.coffee');
	api.addFiles('lib/callbacks.coffee');
	api.addFiles('lib/fileUploadRestrictions.js');
	api.addFiles('lib/placeholders.js');
	api.addFiles('lib/promises.coffee');
	api.addFiles('lib/roomTypesCommon.coffee');
	api.addFiles('lib/slashCommand.coffee');
	api.addFiles('lib/Message.coffee');
	api.addFiles('lib/MessageTypes.coffee');

	api.addFiles('lib/utils.js');

	api.addFiles('server/lib/bugsnag.js', 'server');

	api.addFiles('server/lib/RateLimiter.coffee', 'server');

	// SERVER CALLBACK
	api.addFiles('server/callback/debateCallback.coffee', 'server');
	api.addFiles('server/callback/followCallback.coffee', 'server');

	// SERVER FUNCTIONS
	api.addFiles('server/functions/addUserToDefaultChannels.js', 'server');
	api.addFiles('server/functions/addUserToRoom.js', 'server');
	api.addFiles('server/functions/archiveRoom.js', 'server');
	api.addFiles('server/functions/checkUsernameAvailability.coffee', 'server');
	api.addFiles('server/functions/checkEmailAvailability.js', 'server');
	api.addFiles('server/functions/createRoom.js', 'server');
	api.addFiles('server/functions/deleteMessage.js', 'server');
	api.addFiles('server/functions/deleteUser.js', 'server');
	api.addFiles('server/functions/removeUserFromRoom.js', 'server');
	api.addFiles('server/functions/saveUser.js', 'server');
	api.addFiles('server/functions/saveCustomFields.js', 'server');
	api.addFiles('server/functions/sendMessage.coffee', 'server');
	api.addFiles('server/functions/settings.coffee', 'server');
	api.addFiles('server/functions/setUserAvatar.js', 'server');
	api.addFiles('server/functions/setUsername.coffee', 'server');
	api.addFiles('server/functions/setEmail.js', 'server');
	api.addFiles('server/functions/unarchiveRoom.js', 'server');
	api.addFiles('server/functions/updateMessage.js', 'server');
	api.addFiles('server/functions/Notifications.coffee', 'server');

	// SERVER LIB
	api.addFiles('server/lib/defaultBlockedDomainsList.js', 'server');
	api.addFiles('server/lib/notifyUsersOnMessage.js', 'server');
	api.addFiles('server/lib/roomTypes.coffee', 'server');
	api.addFiles('server/lib/sendEmailOnMessage.js', 'server');
	api.addFiles('server/lib/sendNotificationsOnMessage.js', 'server');
	api.addFiles('server/lib/validateEmailDomain.js', 'server');

	api.addFiles('server/lib/DebateUtils.coffee', 'server');
	api.addFiles('server/lib/tagTypes.coffee','server');
	api.addFiles('server/lib/ActivityUtils.coffee', 'server');
	api.addFiles('server/lib/ScoreUtils.coffee', 'server');


	// SERVER MODELS
	api.addFiles('server/models/_Base.js', 'server');
	api.addFiles('server/models/Messages.coffee', 'server');
	api.addFiles('server/models/Reports.coffee', 'server');
	api.addFiles('server/models/Rooms.coffee', 'server');
	api.addFiles('server/models/Settings.coffee', 'server');
	api.addFiles('server/models/Subscriptions.coffee', 'server');
	api.addFiles('server/models/Uploads.coffee', 'server');
	api.addFiles('server/models/Users.coffee', 'server');

	api.addFiles('server/models/Debates.coffee', 'server');
	api.addFiles('server/models/DebateHistories.coffee', 'server');
	api.addFiles('server/models/DebateSubscriptions.coffee', 'server');
	api.addFiles('server/models/Friend.coffee', 'server');
	api.addFiles('server/models/Devices.coffee', 'server');
	api.addFiles('server/models/FriendsSubscriptions.coffee','server');
	api.addFiles('server/models/Ad.coffee','server');
	api.addFiles('server/models/Tags.coffee','server');
	api.addFiles('server/models/Activity.coffee', 'server');
	api.addFiles('server/models/Score.coffee', 'server');
	api.addFiles('server/models/Searchs.coffee', 'server');
	// SERVER PUBLICATIONS
	api.addFiles('server/publications/settings.coffee', 'server');

	api.addFiles('server/publications/debateSubscription.coffee', 'server');
	api.addFiles('server/publications/debate.coffee', 'server');
	api.addFiles('server/publications/userDebates.coffee', 'server');
	api.addFiles('server/publications/tag.coffee','server');
	api.addFiles('server/publications/follow.coffee','server');
	api.addFiles('server/publications/friendSubscriptionData.coffee','server');
	api.addFiles('server/publications/tagAutocomplete.coffee','server');
	api.addFiles('server/publications/roleAutocomplete.coffee','server');
	api.addFiles('server/publications/typeSelectTag.coffee','server');

	// SERVER METHODS
	api.addFiles('server/methods/addOAuthService.coffee', 'server');
	api.addFiles('server/methods/addUserToRoom.coffee', 'server');
	api.addFiles('server/methods/archiveRoom.coffee', 'server');
	api.addFiles('server/methods/checkRegistrationSecretURL.coffee', 'server');
	api.addFiles('server/methods/createChannel.coffee', 'server');
	api.addFiles('server/methods/createPrivateGroup.coffee', 'server');
	api.addFiles('server/methods/deleteMessage.coffee', 'server');
	api.addFiles('server/methods/deleteUserOwnAccount.js', 'server');
	api.addFiles('server/methods/getRoomRoles.js', 'server');
	api.addFiles('server/methods/getUserRoles.js', 'server');
	api.addFiles('server/methods/joinRoom.coffee', 'server');
	api.addFiles('server/methods/joinDefaultChannels.coffee', 'server');
	api.addFiles('server/methods/leaveRoom.coffee', 'server');
	api.addFiles('server/methods/removeOAuthService.coffee', 'server');
	api.addFiles('server/methods/robotMethods.coffee', 'server');
	api.addFiles('server/methods/saveSetting.js', 'server');
	api.addFiles('server/methods/sendInvitationEmail.coffee', 'server');
	api.addFiles('server/methods/sendMessage.coffee', 'server');
	api.addFiles('server/methods/sendSMTPTestEmail.coffee', 'server');
	api.addFiles('server/methods/setAdminStatus.coffee', 'server');
	api.addFiles('server/methods/setRealName.coffee', 'server');
	api.addFiles('server/methods/setUsername.coffee', 'server');
	api.addFiles('server/methods/insertOrUpdateUser.coffee', 'server');
	api.addFiles('server/methods/setEmail.js', 'server');
	api.addFiles('server/methods/restartServer.coffee', 'server');
	api.addFiles('server/methods/unarchiveRoom.coffee', 'server');
	api.addFiles('server/methods/updateMessage.coffee', 'server');
	api.addFiles('server/methods/filterBadWords.js', ['server']);
	api.addFiles('server/methods/filterATAllTag.js', 'server');

	api.addFiles('server/methods/createDebate.coffee', 'server');
	api.addFiles('server/methods/loadDebates.coffee', 'server');
	api.addFiles('server/methods/getDebate.coffee', 'server');
	api.addFiles('server/methods/updateDebateRead.coffee', 'server');
	api.addFiles('server/methods/updateDebateTag.coffee', 'server');
	api.addFiles('server/methods/updateDebateShare.coffee', 'server');
	api.addFiles('server/methods/updateDebateFavorite.coffee', 'server');
	api.addFiles('server/methods/joinTag.coffee', 'server');
	api.addFiles('server/methods/openTag.coffee','server');
	api.addFiles('server/methods/createTag.coffee','server');
	api.addFiles('server/methods/canAccessTag.coffee','server');
	api.addFiles('server/methods/readDebates.coffee','server');
	api.addFiles('server/methods/joinWebrtc.coffee','server');
	api.addFiles('server/methods/leaveWebrtc.coffee','server');
	api.addFiles('server/methods/clearWebrtc.coffee','server');
	api.addFiles('server/methods/setShortCountry.coffee','server');
	api.addFiles('server/methods/searchUsers.coffee','server');
	api.addFiles('server/methods/searchDebates.coffee','server');
	api.addFiles('server/methods/createAd.coffee','server');
	api.addFiles('server/methods/setIntroduction.js','server');

	api.addFiles('server/methods/startDebate.coffee','server');
	api.addFiles('server/methods/unstartDebate.coffee','server');
	api.addFiles('server/methods/addFollow.coffee','server');
	api.addFiles('server/methods/cancelFollow.coffee','server');
	api.addFiles('server/methods/loadTypeDebates.coffee','server');
	api.addFiles('server/methods/loadNextTypeDebates.coffee','server');
	api.addFiles('server/methods/loadUserDebates.coffee','server');
	api.addFiles('server/methods/loadNextUserDebates.coffee','server');
	api.addFiles('server/methods/removeDebateTag.coffee','server');
	
	// SERVER STARTUP
	api.addFiles('server/startup/settingsOnLoadCdnPrefix.coffee', 'server');
	api.addFiles('server/startup/settingsOnLoadSMTP.coffee', 'server');
	api.addFiles('server/startup/oAuthServicesUpdate.coffee', 'server');
	api.addFiles('server/startup/settings.coffee', 'server');

	// COMMON STARTUP
	api.addFiles('lib/startup/settingsOnLoadSiteUrl.coffee');

	// CLIENT LIB
	api.addFiles('client/Notifications.coffee', 'client');
	api.addFiles('client/lib/cachedCollection.js', 'client');
	api.addFiles('client/lib/openRoom.coffee', 'client');
	api.addFiles('client/lib/roomExit.coffee', 'client');
	api.addFiles('client/lib/settings.coffee', 'client');
	api.addFiles('client/lib/roomTypes.coffee', 'client');
	api.addFiles('client/lib/userRoles.js', 'client');
	api.addFiles('client/lib/Layout.js', 'client');

	api.addFiles('client/lib/tagTypes.coffee', 'client');

	// CLIENT METHODS
	api.addFiles('client/methods/sendMessage.coffee', 'client');
	api.addFiles('client/AdminBox.coffee', 'client');
	api.addFiles('client/TabBar.coffee', 'client');
	api.addFiles('client/MessageAction.coffee', 'client');

	api.addFiles('client/defaultTabBars.js', 'client');
	api.addFiles('client/CustomTranslations.js', 'client');

	api.addFiles('client/HeaderOptsAction.coffee', 'client');
	api.addFiles('client/OptionTabBar.coffee', 'client');
	api.addFiles('client/defaultOptionTabBar.js', 'client');

	// CLIENT MODELS
	api.addFiles('client/models/_Base.coffee', 'client');
	api.addFiles('client/models/Uploads.coffee', 'client');

	api.addFiles('startup/defaultRoomTypes.coffee');

	api.addFiles('startup/defaultTagTypes.coffee', 'client');

	// VERSION
	api.addFiles('tagt.info');

	// EXPORT
	api.export('TAGT');

	api.imply('tap:i18n');
});



Package.onTest(function(api) {
	api.use('coffeescript');
	api.use('sanjo:jasmine@0.20.2');
	api.use('tagt:lib');
	api.addFiles('tests/jasmine/server/unit/models/_Base.spec.coffee', 'server');
});
