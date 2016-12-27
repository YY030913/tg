FlowRouter.route '/admin/medal',
	name: 'admin-medal'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-medal'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Tag')
			pageTemplate: 'medals'

FlowRouter.route '/admin/medal/:name?/edit',
	name: 'admin-medal-edit'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-medal'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Role_Editing')
			pageTemplate: 'medalRole'

FlowRouter.route '/admin/medal/new',
	name: 'admin-medal-new'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-medal'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Role_Editing')
			pageTemplate: 'medalRole'
