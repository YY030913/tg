TAGT._setUsername = (userId, username) ->
	username = s.trim username
	if not userId or not username
		return false

	try
		nameValidation = new RegExp '^' + TAGT.settings.get('UTF8_Names_Validation') + '$'
	catch
		nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

	if not nameValidation.test username
		return false

	user = TAGT.models.Users.findOneById userId

	# User already has desired username, return
	if user.username is username
		return user

	previousUsername = user.username

	# Check username availability or if the user already owns a different casing of the name
	if ( !previousUsername or !(username.toLowerCase() == previousUsername.toLowerCase()))
		unless TAGT.checkUsernameAvailability username
			return false

	# If first time setting username, send Enrollment Email
	try
		if not previousUsername and user.emails?.length > 0 and TAGT.settings.get 'Accounts_Enrollment_Email'
			Accounts.sendEnrollmentEmail(user._id)
	catch error

	# Username is available; if coming from old username, update all references
	if previousUsername
		TAGT.models.Messages.updateAllUsernamesByUserId user._id, username
		TAGT.models.Messages.updateUsernameOfEditByUserId user._id, username

		TAGT.models.Messages.findByMention(previousUsername).forEach (msg) ->
			updatedMsg = msg.msg.replace(new RegExp("@#{previousUsername}", "ig"), "@#{username}")
			TAGT.models.Messages.updateUsernameAndMessageOfMentionByIdAndOldUsername msg._id, previousUsername, username, updatedMsg

		TAGT.models.Rooms.replaceUsername previousUsername, username
		TAGT.models.Rooms.replaceMutedUsername previousUsername, username
		TAGT.models.Rooms.replaceUsernameOfUserByUserId user._id, username

		TAGT.models.Subscriptions.setUserUsernameByUserId user._id, username
		TAGT.models.Subscriptions.setNameForDirectRoomsWithOldName previousUsername, username

		rs = TAGTFileAvatarInstance.getFileWithReadStream(encodeURIComponent("#{previousUsername}.jpg"))
		if rs?
			TAGTFileAvatarInstance.deleteFile encodeURIComponent("#{username}.jpg")
			ws = TAGTFileAvatarInstance.createWriteStream encodeURIComponent("#{username}.jpg"), rs.contentType
			ws.on 'end', Meteor.bindEnvironment ->
				TAGTFileAvatarInstance.deleteFile encodeURIComponent("#{previousUsername}.jpg")
			rs.readStream.pipe(ws)

		TAGT.models.Debates.updateAllUsernamesByUserId userId, username
		TAGT.models.Debates.replaceUsername previousUsername, username

		TAGT.models.DebateSubscriptions.updateAllUsernamesByUserId userId, username

		TAGT.models.DebateHistories.updateAllUsernamesByUserId userId, username
		
	pinyin = Npm.require('pinyin');
	TAGT.models.Users.setUsername userId, username
	username_pinyin_array = pinyin(username, {heteronym: true, segment: true })
	username_pinyin_str = ""
	for item in username_pinyin_array
		username_pinyin_str = username_pinyin_str + item[0].split(",")[0] + " "
	TAGT.models.Users.setPinyin userId, username_pinyin_str

	if _.indexOf(user.medals, 'Medal_Start')<0
		TAGT.models.Users.addMedalsByUserId userId, "Medal_Start"
		
	user.username = username
	user.pinyin = pinyin(username, {heteronym: true, segment: true })
	return user


TAGT.setUsername = TAGT.RateLimiter.limitFunction TAGT._setUsername, 1, 60000,
	0: () -> return not Meteor.userId() or not TAGT.authz.hasPermission(Meteor.userId(), 'edit-other-user-info') # Administrators have permission to change others usernames, so don't limit those
