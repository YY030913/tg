currentTracker = undefined

@openTag = (type, tag) ->
	Session.set 'openedTag', null

	Meteor.defer ->
		currentTracker = Tracker.autorun (c) ->
			if TagManager.open(type + tag).ready() isnt true
				# $("body").removeClass("loaded")
				BlazeLayout.render 'main', {center: 'pageLoading'}
				return

			user = Meteor.user()
			unless user?.username
				return

			currentTracker = undefined
			c.stop()
			
			tagRecord = TAGT.tagTypes.findTag(type, tag)
			if not tag?
				Session.set 'tagNotFound', {tag: tag}
				BlazeLayout.render 'main', {center: 'tagNotFound'}
				return

			# $('#loader-wrapper').remove();
			# $("body").addClass("loaded")
			mainNode = document.querySelector('.main-content')
			if mainNode?
				for child in mainNode.children
					mainNode.removeChild child if child?
				tagDom = TagManager.getDomOfTag(type + tag, tagRecord._id)
				mainNode.appendChild tagDom
				if tagDom.classList.contains('tag-container')
					tagDom.querySelector('.container > .wrapper').scrollTop = tagDom.oldScrollTop

			Session.set 'openedTag', tagRecord._id

			# update tagRecord's debate subscription
			sub = DebateSubscription.findOne({fid: tagRecord._id})
			if sub?.open is false
				Meteor.call 'openTag', tagRecord._id, (err) ->
					if err
						return handleError(err)

			TAGT.callbacks.run 'enter-tag', sub