logger = new Logger 'steffo:meteor-accounts-saml',
	methods:
		updated:
			type: 'info'

TAGT.settings.addGroup 'SAML'
Meteor.methods
	addSamlService: (name) ->
		TAGT.settings.add "SAML_Custom_#{name}"                   , false                                                         , { type: 'boolean', group: 'SAML', section: name, i18nLabel: 'Accounts_OAuth_Custom_Enable'}
		TAGT.settings.add "SAML_Custom_#{name}_provider"          , 'openidp'                                                     , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Provider'}
		TAGT.settings.add "SAML_Custom_#{name}_entry_point"       , 'https://openidp.feide.no/simplesaml/saml2/idp/SSOService.php', { type: 'string' , group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Entry_point'}
		TAGT.settings.add "SAML_Custom_#{name}_issuer"            , 'https://caoliao.net.cn/'                                        , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Issuer'}
		TAGT.settings.add "SAML_Custom_#{name}_cert"              , ''                                                            , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Cert'}
		TAGT.settings.add "SAML_Custom_#{name}_button_label_text" , ''                                                            , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'Accounts_OAuth_Custom_Button_Label_Text'}
		TAGT.settings.add "SAML_Custom_#{name}_button_label_color", '#FFFFFF'                                                     , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'Accounts_OAuth_Custom_Button_Label_Color'}
		TAGT.settings.add "SAML_Custom_#{name}_button_color"      , '#13679A'                                                     , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'Accounts_OAuth_Custom_Button_Color'}
		TAGT.settings.add "SAML_Custom_#{name}_generate_username" , false                                                         , { type: 'boolean', group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Generate_Username'}

timer = undefined
updateServices = ->
	Meteor.clearTimeout timer if timer?

	timer = Meteor.setTimeout ->
		services = TAGT.models.Settings.find({_id: /^(SAML_Custom_)[a-z]+$/i}).fetch()

		Accounts.saml.settings.providers = []

		for service in services
			logger.updated service._id

			serviceName = 'saml'

			if service.value is true
				data =
					buttonLabelText: TAGT.models.Settings.findOneById("#{service._id}_button_label_text")?.value
					buttonLabelColor: TAGT.models.Settings.findOneById("#{service._id}_button_label_color")?.value
					buttonColor: TAGT.models.Settings.findOneById("#{service._id}_button_color")?.value
					clientConfig:
						provider: TAGT.models.Settings.findOneById("#{service._id}_provider")?.value

				Accounts.saml.settings.generateUsername = TAGT.models.Settings.findOneById("#{service._id}_generate_username")?.value

				Accounts.saml.settings.providers.push
					provider: data.clientConfig.provider
					entryPoint: TAGT.models.Settings.findOneById("#{service._id}_entry_point")?.value
					issuer: TAGT.models.Settings.findOneById("#{service._id}_issuer")?.value
					cert: TAGT.models.Settings.findOneById("#{service._id}_cert")?.value

				ServiceConfiguration.configurations.upsert {service: serviceName.toLowerCase()}, $set: data
			else
				ServiceConfiguration.configurations.remove {service: serviceName.toLowerCase()}
	, 2000

TAGT.models.Settings.find().observe
	added: (record) ->
		if /^SAML_.+/.test record._id
			updateServices()

	changed: (record) ->
		if /^SAML_.+/.test record._id
			updateServices()

	removed: (record) ->
		if /^SAML_.+/.test record._id
			updateServices()

Meteor.startup ->
	if not TAGT.models.Settings.findOne({_id: /^(SAML_Custom)_[a-z]+$/i})?
		Meteor.call 'addSamlService', 'Default'
