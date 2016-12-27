Meteor.methods
	sendInvitationEmail: (emails) ->

		check emails, [String]

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'sendInvitationEmail' }

		unless TAGT.authz.hasRole(Meteor.userId(), 'admin')
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'sendInvitationEmail' }

		rfcMailPattern = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
		validEmails = _.compact _.map emails, (email) -> return email if rfcMailPattern.test email

		header = TAGT.placeholders.replace(TAGT.settings.get('Email_Header') || "")
		footer = TAGT.placeholders.replace(TAGT.settings.get('Email_Footer') || "")

		if TAGT.settings.get('Invitation_Customized')
			subject = TAGT.settings.get('Invitation_Subject')
			html = TAGT.settings.get('Invitation_HTML')
		else
			subject = TAPi18n.__('Invitation_Subject_Default', { lng: Meteor.user()?.language || TAGT.settings.get('language') || 'en' })
			html = TAPi18n.__('Invitation_HTML_Default', { lng: Meteor.user()?.language || TAGT.settings.get('language') || 'en' })

		subject = TAGT.placeholders.replace(subject);

		for email in validEmails
			@unblock()

			html = TAGT.placeholders.replace(html, { email: email });

			try
				Email.send
					to: email
					from: TAGT.settings.get 'From_Email'
					subject: subject
					html: header + html + footer
			catch error
				throw new Meteor.Error 'error-email-send-failed', 'Error trying to send email: ' + error.message, { method: 'sendInvitationEmail', message: error.message }


		return validEmails
