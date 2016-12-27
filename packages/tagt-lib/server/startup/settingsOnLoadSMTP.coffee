buildMailURL = _.debounce ->
	console.log 'Updating process.env.MAIL_URL'
	if TAGT.settings.get('SMTP_Host')
		process.env.MAIL_URL = "smtp://"
		if TAGT.settings.get('SMTP_Username') and TAGT.settings.get('SMTP_Password')
			process.env.MAIL_URL += encodeURIComponent(TAGT.settings.get('SMTP_Username')) + ':' + encodeURIComponent(TAGT.settings.get('SMTP_Password')) + '@'
		process.env.MAIL_URL += encodeURIComponent(TAGT.settings.get('SMTP_Host'))
		if TAGT.settings.get('SMTP_Port')
			process.env.MAIL_URL += ':' + parseInt(TAGT.settings.get('SMTP_Port'))
, 500

TAGT.settings.onload 'SMTP_Host', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

TAGT.settings.onload 'SMTP_Port', (key, value, initialLoad) ->
	buildMailURL()

TAGT.settings.onload 'SMTP_Username', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

TAGT.settings.onload 'SMTP_Password', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

Meteor.startup ->
	buildMailURL()
