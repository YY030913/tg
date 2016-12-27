Template.flexTabBar.helpers
	active: ->
		return 'active' if @template is TAGT.TabBar.getTemplate() and TAGT.TabBar.isFlexOpen()
	buttons: ->
		return TAGT.TabBar.getButtons()
	title: ->
		return t(@i18nTitle) or @title
	visible: ->
		if @groups.indexOf(TAGT.TabBar.getVisibleGroup()) is -1
			return 'hidden'

Template.flexTabBar.events
	'click .tab-button': (e, t) ->
		e.preventDefault()

		if TAGT.TabBar.isFlexOpen() and TAGT.TabBar.getTemplate() is @template
			TAGT.TabBar.closeFlex()
			$('.flex-tab').css('max-width', '')
			$('.main-content').css('right', '')
		else
			if not @openClick? or @openClick(e,t)
				if @width?
					$('.flex-tab').css('max-width', "#{@width}px")
					$('.main-content').css('right', "#{@width + 40}px")
				else
					$('.flex-tab').css('max-width', '')

				TAGT.TabBar.setTemplate @template, ->
					$('.flex-tab')?.find("input[type='text']:first")?.focus()
					$('.flex-tab .content')?.scrollTop(0)

Template.flexTabBar.onCreated ->
	# close flex if the visible group changed and the opened template is not in the new visible group
	@autorun =>
		visibleGroup = TAGT.TabBar.getVisibleGroup()

		Tracker.nonreactive =>
			openedTemplate = TAGT.TabBar.getTemplate()
			exists = false
			TAGT.TabBar.getButtons().forEach (button) ->
				if button.groups.indexOf(visibleGroup) isnt -1 and openedTemplate is button.template
					exists = true

			unless exists
				TAGT.TabBar.closeFlex()
