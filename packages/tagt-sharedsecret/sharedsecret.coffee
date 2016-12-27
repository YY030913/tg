SharedSecret = []

if (Meteor.isServer)
	class EncryptMessage
		constructor: (message) ->
			currentUser = Meteor.user()._id
			currentRoomId = message.rid

			if(SharedSecret? && SharedSecret[currentUser]? && SharedSecret[currentUser][currentRoomId]?)
				currentSecret = SharedSecret[currentUser][currentRoomId]
				encrypted = CryptoJS.AES.encrypt(message.msg, currentSecret)
				message.msg = encrypted.toString()

				#urls
				if(message.urls)
					for urls in message.urls
						urls.url = CryptoJS.AES.encrypt(urls.url, currentSecret).toString()

				message.encrypted = true

			return message

	class HandleSlashCommand
		constructor: (command, params, item) ->
			if(command == "setsecretkey")
				currentUser = Meteor.user()._id
				currentRoomId = item.rid
				secret = params

				if(secret == "off")
					secret = null

				if(SharedSecret[currentUser]?)
					SharedSecret[currentUser][currentRoomId] = secret
				else
					SharedSecret[currentUser] = []
					SharedSecret[currentUser][currentRoomId] = secret

	TAGT.callbacks.add 'beforeSaveMessage', EncryptMessage, 9999 #LAST
	TAGT.slashCommands.add 'setsecretkey', HandleSlashCommand

if (Meteor.isClient)
	class DecryptMessage
		constructor: (message) ->
			if(message.encrypted)
				currentRoomId = message.rid
				currentSecret = localStorage.getItem("talk.get.sharedSecretKey.#{currentRoomId}")

				if(currentSecret?)
					decrypted = CryptoJS.AES.decrypt(message.msg, currentSecret).toString(CryptoJS.enc.Utf8)

					if(decrypted == "")
						message.msg = "~ encrypted message ~"
						message.html = "~ encrypted message ~"
					else
						lockImage = "images/lock8.png"
						message.msg = "<img src=#{lockImage} style='width:8px;height:9px;'></img> " + decrypted
						message.html = "<img src=#{lockImage} style='width:8px;height:9px;'></img> " + decrypted

					#urls
					if(message.urls)
						for urls in message.urls
							urls.url = CryptoJS.AES.decrypt(urls.url, currentSecret).toString(CryptoJS.enc.Utf8)
				else
					message.msg = "~ encrypted message ~"
					message.html = "~ encrypted message ~"

			return message

	class HandleSlashCommand
		constructor: (command, params, item) ->
			if(command == "setsecretkey")
				secret = params
				if(secret == "off")
					secret = null
				currentRoomId = item.rid
				localStorage.setItem("talk.get.sharedSecretKey.#{currentRoomId}", secret)



	TAGT.callbacks.add 'renderMessage', DecryptMessage, -9999 #FIRST
	TAGT.slashCommands.add 'setsecretkey', HandleSlashCommand
