Template.popDebateTagInput.helpers

	autocompleteSettings: ->
		return {
			limit: 10
			# inputDelay: 300
			rules: [
				{
					# @TODO maybe change this 'collection' and/or template
					collection: 'DebateAndTag'
					subscription: 'tagAutocomplete'
					field: 'name'
					template: Template.tagSearch
					noMatchTemplate: Template.tagSearchEmpty
					matchAll: true
					filter:
						exceptions: [Meteor.user().username].concat(Template.instance().selectedTags.get())
					selector: (match) ->
						return { username: match }
					sort: 'username'
				}
			]
		}


Template.popDebateTagInput.events
	'autocompleteselect #debate-tags': (event, instance, doc) ->
		instance.selectedTags.set instance.selectedTags.get().concat doc.username

		instance.selectedUserNames[doc.username] = doc.name

		event.currentTarget.value = ''
		event.currentTarget.focus()

	'click .remove-room-member': (e, instance) ->
		self = @

		users = Template.instance().selectedTags.get()
		users = _.reject Template.instance().selectedTags.get(), (_id) ->
			return _id is self.valueOf()

		Template.instance().selectedTags.set(users)

		$('#debate-tags').focus()


	'keydown #debate-tags': (e, instance) ->
		input = e.currentTarget
		$input = $(input)
		k = e.which
		if k is 13 and not e.shiftKey # Enter without shift
			e.preventDefault()
			e.stopPropagation()
			err = SideNav.validate()
			name = instance.find('#debate-tags').value.toLowerCase().trim()
			tag = {
				name: name
			}
			if not err
				console.log "updateDebateTag"
				Meteor.call "updateDebateTag", FlowRouter.current().params.slug, tag, (error, result)->
				if error?
					throw new Meteor.Error 'error-update-debate-tag', "A debate '" + debate.name + "' with tag news error'"
				$("#debate-tag-input").toggle();
			else
				console.log err
				instance.error.set({ fields: err })

Template.popDebateTagInput.onCreated ->
	instance = this
	instance.selectedTags = new ReactiveVar []
	
	instance.clearForm = ->
		instance.selectedTags.set([])