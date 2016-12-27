FlowRouter.route '/admin/tags',
	name: 'admin-tags'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-tags'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Tag')
			pageTemplate: 'tags'

FlowRouter.route '/admin/tags/:name?/edit',
	name: 'admin-tags-edit'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-tags'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Role_Editing')
			pageTemplate: 'tagsRole'

FlowRouter.route '/admin/tags/new',
	name: 'admin-tags-new'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-tags'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Role_Editing')
			pageTemplate: 'tagsRole'
