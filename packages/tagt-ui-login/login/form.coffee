Template.loginForm.helpers
	userName: ->
		return Meteor.user()?.username

	namePlaceholder: ->
		return if TAGT.settings.get 'Accounts_RequireNameForSignUp' then t('Name') else t('Name_optional')

	showFormLogin: ->
		return TAGT.settings.get 'Accounts_ShowFormLogin'

	state: (state..., data) ->
		return state.indexOf(Template.instance().state.get()) > -1

	btnLoginSave: ->
		switch Template.instance().state.get()
			when 'register'
				return t('Register')
			when 'login'
				return t('Login')
			when 'email-verification'
				return t('Send_confirmation_email')
			when 'forgot-password'
				return t('Reset_password')

	loginTerms: ->
		return TAGT.settings.get 'Layout_Login_Terms'

	registrationAllowed: ->
		return TAGT.settings.get('Accounts_RegistrationForm') is 'Public' or Template.instance().validSecretURL?.get()

	linkReplacementText: ->
		return TAGT.settings.get('Accounts_RegistrationForm_LinkReplacementText')

	passwordResetAllowed: ->
		return TAGT.settings.get 'Accounts_PasswordReset'

	requirePasswordConfirmation: ->
		return TAGT.settings.get 'Accounts_RequirePasswordConfirmation'

	emailOrUsernamePlaceholder: ->
		return TAGT.settings.get('Accounts_EmailOrUsernamePlaceholder') or t("Email_or_username")

	passwordPlaceholder: ->
		return TAGT.settings.get('Accounts_PasswordPlaceholder') or t("Password")

	hasOnePassword: ->
		return OnePassword?.findLoginForUrl? && device?.platform?.toLocaleLowerCase() is 'ios'

	customFields: ->
		if not Template.instance().customFields.get()
			return []

		customFieldsArray = []
		for key, value of Template.instance().customFields.get()
			if value.hideFromForm is true
				continue

			customFieldsArray.push
				fieldName: key,
				field: value

		return customFieldsArray


Template.loginForm.events
	'submit #login-card': (event, instance) ->
		event.preventDefault()

		button = $(event.target).find('button.login')
		TAGT.Button.loading(button)

		formData = instance.validate()
		if formData
			if instance.state.get() is 'email-verification'
				Meteor.call 'sendConfirmationEmail', s.trim(formData.email), (err, result) ->
					TAGT.Button.reset(button)
					TAGT.callbacks.run('userConfirmationEmailRequested');
					toastr.success t('We_have_sent_registration_email')
					instance.state.set 'login'
				return

			if instance.state.get() is 'forgot-password'
				Meteor.call 'sendForgotPasswordEmail', s.trim(formData.email), (err, result) ->
					if err
						handleError(err)
						instance.state.set 'login'
					else
						TAGT.Button.reset(button)
						TAGT.callbacks.run('userForgotPasswordEmailRequested');
						toastr.success t('We_have_sent_password_email')
						instance.state.set 'login'
				return

			if instance.state.get() is 'register'
				formData.secretURL = FlowRouter.getParam 'hash'
				Meteor.call 'registerUser', formData, (error, result) ->
					TAGT.Button.reset(button)

					if error?
						if error.reason is 'Email already exists.'
							toastr.error t 'Email_already_exists'
						else
							handleError(error)
						return

					TAGT.callbacks.run('userRegistered');

					Meteor.loginWithPassword s.trim(formData.email), formData.pass, (error) ->
						if error?.error is 'error-invalid-email'
							toastr.success t('We_have_sent_registration_email')
							instance.state.set 'login'
						else if error?.error is 'error-user-is-not-activated'
							instance.state.set 'wait-activation'

			else
				loginMethod = 'loginWithPassword'
				if TAGT.settings.get('LDAP_Enable')
					loginMethod = 'loginWithLDAP'
				if TAGT.settings.get('CROWD_Enable')
					loginMethod = 'loginWithCrowd'
				Meteor[loginMethod] s.trim(formData.emailOrUsername), formData.pass, (error) ->
					TAGT.Button.reset(button)
					if error?
						if error.error is 'no-valid-email'
							instance.state.set 'email-verification'
						else
							toastr.error t 'User_not_found_or_incorrect_password'
						return
					localStorage.setItem('userLanguage', Meteor.user()?.language)
					setLanguage(Meteor.user()?.language)

	'click .register': ->
		Template.instance().state.set 'register'
		TAGT.callbacks.run('loginPageStateChange', Template.instance().state.get());

	'click .back-to-login': ->
		Template.instance().state.set 'login'
		TAGT.callbacks.run('loginPageStateChange', Template.instance().state.get());

	'click .forgot-password': ->
		Template.instance().state.set 'forgot-password'
		TAGT.callbacks.run('loginPageStateChange', Template.instance().state.get());

	'click .one-passsword': ->
		if not OnePassword?.findLoginForUrl?
			return

		succesCallback = (credentials) ->
			$('input[name=emailOrUsername]').val(credentials.username)
			$('input[name=pass]').val(credentials.password)

		errorCallback = ->
			console.log 'OnePassword errorCallback', arguments

		OnePassword.findLoginForUrl(succesCallback, errorCallback, Meteor.absoluteUrl())

	'focus .input-text input': (event) ->
		$(event.currentTarget).parents('.input-text').addClass('focus')

	'blur .input-text input': (event) ->
		if event.currentTarget.value is ''
			$(event.currentTarget).parents('.input-text').removeClass('focus')


Template.loginForm.onCreated ->
	instance = @
	@customFields = new ReactiveVar

	Tracker.autorun =>
		Accounts_CustomFields = TAGT.settings.get('Accounts_CustomFields')
		if typeof Accounts_CustomFields is 'string' and Accounts_CustomFields.trim() isnt ''
			try
				@customFields.set JSON.parse TAGT.settings.get('Accounts_CustomFields')
			catch e
				console.error('Invalid JSON for Accounts_CustomFields')
		else
			@customFields.set undefined

	if Meteor.settings.public.sandstorm
		@state = new ReactiveVar('sandstorm')
	else if Session.get 'loginDefaultState'
		@state = new ReactiveVar(Session.get 'loginDefaultState')
	else
		@state = new ReactiveVar('login')

	@validSecretURL = new ReactiveVar(false)

	validateCustomFields = (formObj, validationObj) ->
		customFields = instance.customFields.get()
		if not customFields
			return

		for field, value of formObj when customFields[field]?
			customField = customFields[field]

			if customField.required is true and not value
				return validationObj[field] = t('Field_required')

			if customField.maxLength? and value.length > customField.maxLength
				return validationObj[field] = t('Max_length_is', customField.maxLength)

			if customField.minLength? and value.length < customField.minLength
				return validationObj[field] = t('Min_length_is', customField.minLength)


	@validate = ->
		formData = $("#login-card").serializeArray()
		formObj = {}
		validationObj = {}

		for field in formData
			formObj[field.name] = field.value

		if instance.state.get() isnt 'login'
			unless formObj['email'] and /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]+\b/i.test(formObj['email'])
				validationObj['email'] = t('Invalid_email')

		if instance.state.get() is 'login'
			unless formObj['emailOrUsername']
				validationObj['emailOrUsername'] = t('Invalid_email')

		if instance.state.get() isnt 'forgot-password'
			unless formObj['pass']
				validationObj['pass'] = t('Invalid_pass')

		if instance.state.get() is 'register'
			if TAGT.settings.get('Accounts_RequireNameForSignUp') and not formObj['name']
				validationObj['name'] = t('Invalid_name')

			if TAGT.settings.get('Accounts_RequirePasswordConfirmation') and formObj['confirm-pass'] isnt formObj['pass']
				validationObj['confirm-pass'] = t('Invalid_confirm_pass')

			validateCustomFields(formObj, validationObj)

		$("#login-card h2").removeClass "error"
		$("#login-card input.error, #login-card select.error").removeClass "error"
		$("#login-card .input-error").text ''

		unless _.isEmpty validationObj
			button = $('#login-card').find('button.login')
			TAGT.Button.reset(button)
			$("#login-card h2").addClass "error"
			for key, value of validationObj
				$("#login-card input[name=#{key}], #login-card select[name=#{key}]").addClass "error"
				$("#login-card input[name=#{key}]~.input-error, #login-card select[name=#{key}]~.input-error").text value
			return false

		return formObj

	if FlowRouter.getParam('hash')
		Meteor.call 'checkRegistrationSecretURL', FlowRouter.getParam('hash'), (err, success) =>
			@validSecretURL.set true

Template.loginForm.onRendered ->
	Session.set 'loginDefaultState'
	Tracker.autorun =>
		TAGT.callbacks.run('loginPageStateChange', this.state.get())
		switch this.state.get()
			when 'login', 'forgot-password', 'email-verification'
				Meteor.defer ->
					$('input[name=email]').select().focus()

			when 'register'
				Meteor.defer ->
					$('input[name=name]').select().focus()
