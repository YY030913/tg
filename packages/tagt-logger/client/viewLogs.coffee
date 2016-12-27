@stdout = new Meteor.Collection 'stdout'

Meteor.startup ->
	TAGT.AdminBox.addOption
		href: 'admin-view-logs'
		i18nLabel: 'View_Logs'
		permissionGranted: ->
			return TAGT.authz.hasAllPermission('view-logs')

FlowRouter.route '/admin/view-logs',
	name: 'admin-view-logs'
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('View_Logs')
			pageTemplate: 'viewLogs'
			noScroll: true
