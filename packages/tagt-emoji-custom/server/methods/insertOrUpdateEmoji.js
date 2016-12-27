/* globals TAGTFileEmojiCustomInstance */
Meteor.methods({
	insertOrUpdateEmoji(emojiData) {
		if (!TAGT.authz.hasPermission(this.userId, 'manage-emoji')) {
			throw new Meteor.Error('not_authorized');
		}

		if (!s.trim(emojiData.name)) {
			throw new Meteor.Error('error-the-field-is-required', 'The field Name is required', { method: 'insertOrUpdateEmoji', field: 'Name' });
		}

		//let nameValidation = new RegExp('^[0-9a-zA-Z-_+;.]+$');
		//let aliasValidation = new RegExp('^[0-9a-zA-Z-_+;., ]+$');

		//allow all characters except colon, whitespace, comma, >, <, &, ", ', /, \, (, )
		//more practical than allowing specific sets of characters; also allows foreign languages
		let nameValidation = /[\s,:><&"'\/\\\(\)]/;
		let aliasValidation = /[:><&"'\/\\\(\)]/;

		//silently strip colon; this allows for uploading :emojiname: as emojiname
		emojiData.name = emojiData.name.replace(/:/g, '');
		emojiData.aliases = emojiData.aliases.replace(/:/g, '');

		if (nameValidation.test(emojiData.name)) {
			throw new Meteor.Error('error-input-is-not-a-valid-field', `${emojiData.name} is not a valid name`, { method: 'insertOrUpdateEmoji', input: emojiData.name, field: 'Name' });
		}

		if (emojiData.aliases) {
			if (aliasValidation.test(emojiData.aliases)) {
				throw new Meteor.Error('error-input-is-not-a-valid-field', `${emojiData.aliases} is not a valid alias set`, { method: 'insertOrUpdateEmoji', input: emojiData.aliases, field: 'Alias_Set' });
			}
			emojiData.aliases = emojiData.aliases.split(/[\s,]/);
			emojiData.aliases = emojiData.aliases.filter(Boolean);
			emojiData.aliases = _.without(emojiData.aliases, emojiData.name);
		} else {
			emojiData.aliases = [];
		}

		let matchingResults = [];

		if (emojiData._id) {
			matchingResults = TAGT.models.EmojiCustom.findByNameOrAliasExceptID(emojiData.name, emojiData._id).fetch();
			for (let alias of emojiData.aliases) {
				matchingResults = matchingResults.concat(TAGT.models.EmojiCustom.findByNameOrAliasExceptID(alias, emojiData._id).fetch());
			}
		} else {
			matchingResults = TAGT.models.EmojiCustom.findByNameOrAlias(emojiData.name).fetch();
			for (let alias of emojiData.aliases) {
				matchingResults = matchingResults.concat(TAGT.models.EmojiCustom.findByNameOrAlias(alias).fetch());
			}
		}

		if (matchingResults.length > 0) {
			throw new Meteor.Error('Custom_Emoji_Error_Name_Or_Alias_Already_In_Use', 'The custom emoji or one of its aliases is already in use', { method: 'insertOrUpdateEmoji' });
		}

		if (!emojiData._id) {
			//insert emoji
			let createEmoji = {
				name: emojiData.name,
				aliases: emojiData.aliases,
				extension: emojiData.extension
			};

			let _id = TAGT.models.EmojiCustom.create(createEmoji);

			TAGT.Notifications.notifyAll('updateEmojiCustom', {emojiData: createEmoji});

			return _id;
		} else {
			//update emoji
			if (emojiData.newFile) {
				TAGTFileEmojiCustomInstance.deleteFile(encodeURIComponent(`${emojiData.name}.${emojiData.extension}`));
				TAGTFileEmojiCustomInstance.deleteFile(encodeURIComponent(`${emojiData.name}.${emojiData.previousExtension}`));
				TAGTFileEmojiCustomInstance.deleteFile(encodeURIComponent(`${emojiData.previousName}.${emojiData.extension}`));
				TAGTFileEmojiCustomInstance.deleteFile(encodeURIComponent(`${emojiData.previousName}.${emojiData.previousExtension}`));

				TAGT.models.EmojiCustom.setExtension(emojiData._id, emojiData.extension);
			} else if (emojiData.name !== emojiData.previousName) {
				let rs = TAGTFileEmojiCustomInstance.getFileWithReadStream(encodeURIComponent(`${emojiData.previousName}.${emojiData.previousExtension}`));
				if (rs !== null) {
					TAGTFileEmojiCustomInstance.deleteFile(encodeURIComponent(`${emojiData.name}.${emojiData.extension}`));
					let ws = TAGTFileEmojiCustomInstance.createWriteStream(encodeURIComponent(`${emojiData.name}.${emojiData.previousExtension}`), rs.contentType);
					ws.on('end', Meteor.bindEnvironment(() =>
						TAGTFileEmojiCustomInstance.deleteFile(encodeURIComponent(`${emojiData.previousName}.${emojiData.previousExtension}`))
						));
					rs.readStream.pipe(ws);
				}
			}

			if (emojiData.name !== emojiData.previousName) {
				TAGT.models.EmojiCustom.setName(emojiData._id, emojiData.name);
			}

			if (emojiData.aliases) {
				TAGT.models.EmojiCustom.setAliases(emojiData._id, emojiData.aliases);
			} else {
				TAGT.models.EmojiCustom.setAliases(emojiData._id, []);
			}

			TAGT.Notifications.notifyAll('updateEmojiCustom', {emojiData});

			return true;
		}
	}
});
