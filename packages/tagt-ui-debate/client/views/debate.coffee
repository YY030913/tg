isSubscribed =  ->
	return FlowRouter.subsReady('debate')

Template.debate.helpers
	currentUser: ->
		return Meteor.userId()
	validEdit: ->
		return Meteor.userId() == TAGT.models.Debate.findOne(FlowRouter.current().params.slug).u._id
	slug: ->
		return FlowRouter.current().params.slug
	userid: ->
		return TAGT.models.Debate.findOne(FlowRouter.current().params.slug).u._id
	pagetitle: ->
		return TAGT.models.Debate.findOne(FlowRouter.current().params.slug).name
	username: ->
		return TAGT.models.Debate.findOne(FlowRouter.current().params.slug).u.username
	time: ->
		return TAGT.models.Debate.findOne(FlowRouter.current().params.slug).ts
	isLiving: ->
		return TAGT.models.Debate.findOne(FlowRouter.current().params.slug).webrtcJoined?.length > 0
	htmlBody: ->
		return TAGT.models.Debate.findOne(FlowRouter.current().params.slug).htmlBody
	createTime: ->
		# moment(this.ts).format('LLL')
		# moment(this.ts).locale(TAPi18n.getLanguage()).format('L LT')
		# moment(this.ts).format('LT') 1:03 PM
		# moment(this.ts).format('LL')August 15, 2016
		# console.log moment(TAGT.models.Debate.findOne(FlowRouter.current().params.slug).ts).locale(TAPi18n.getLanguage()).format('YYYY-MM-DD')
		if moment().diff(moment(TAGT.models.Debate.findOne(FlowRouter.current().params.slug).ts), 'days') >= 1
			return moment(TAGT.models.Debate.findOne(FlowRouter.current().params.slug).ts).locale(TAPi18n.getLanguage()).format('YYYY-MM-DD')
		else
			return moment(TAGT.models.Debate.findOne(FlowRouter.current().params.slug).ts).locale(TAPi18n.getLanguage()).fromNow();

	isSub: ->
		return isSubscribed();
	isEmpty: ->
		return TAGT.models.Debate.find(FlowRouter.current().params.slug).count() == 0;

	debatetags: ->
		return TAGT.models.Debate.findOne(FlowRouter.current().params.slug).tags

	started: ->
		return false;

	imageMogr: (html)->
		width = $(window).width() - 50
		return TAGT.utils.extendImgSrcs(html, "?imageMogr2/thumbnail/#{width}/quality/100")

	canEditTag: (type) ->
		if type!="o"
			return Meteor.userId() == TAGT.models.Debate.findOne(FlowRouter.current().params.slug).u._id
		return false

	canAddTag: ->
		return Meteor.userId() == TAGT.models.Debate.findOne(FlowRouter.current().params.slug).u._id || _.contains(Meteor.user().roles, "admin")

Template.debate.onRendered ->
	self = this

	Meteor.call("updateDebateRead", FlowRouter.current().params.slug)


Template.debate.events
	'keyup .edit-label': (event, instance)->
		event.preventDefault()
		event.stopPropagation()
		if event.which is 13
			if _.trim($(event.target).text()) isnt ''
				tag = {
					_id: $(event.target).data("id"),
					name: _.trim($(event.target).text())
				}
				$(event.target).text('')
				event.preventDefault()
				event.stopPropagation()
				Meteor.call("updateDebateTag", FlowRouter.current().params.slug, tag, (error, result)->
					if error?
						toastr.error t(error.message)
				);
	'click .add-label': (event, instance)->
		$("#debate-tag-input").toggle();
	'click .icon-star-empty': (event, instance)->
		Meteor.call("startDebate", FlowRouter.current().params.slug, (error, result)->
			if error?
				toastr.error t(error.message)
		);
	'click .icon-star': (event, instance)->
		Meteor.call("unstartDebate", FlowRouter.current().params.slug, (error, result)->
			if error?
				toastr.error t(error.message)
		);

	'click .icon-share': (event, instance)->
		event.preventDefault()
		options = [{
		    message: 'share this',
		    subject: 'the subject', 
		    files: ['', ''],
		    url: 'https://www.website.com/foo/#bar?a=b',
		    chooserTitle: 'Pick an app'
		}]

		onSuccess = (result) ->
		    console.log("Share completed? " + result.completed);
		    console.log("Shared to app: " + result.app);


		onError = (msg) ->
		    console.log("Sharing failed with message: " + msg);


		window.plugins.socialsharing.share(options, onSuccess, onError);

	'click .icon-comment-a': (event, instance)->
		
		if !ChatSubscription.findOne({rid: TAGT.models.Debate.findOne(FlowRouter.current().params.slug).rid})?
			Meteor.call("joinRoom", TAGT.models.Debate.findOne(FlowRouter.current().params.slug).rid, (error, result)->
				if error?
					toastr.error t(error.message)
					return
				else
					FlowRouter.goToRoomById TAGT.models.Debate.findOne(FlowRouter.current().params.slug).rid
			);
		else
			FlowRouter.goToRoomById TAGT.models.Debate.findOne(FlowRouter.current().params.slug).rid

	'click .mdi-navigation-close': (event, instance)->
		Meteor.call "removeDebateTag", FlowRouter.current().params.slug, $(event.target).data("id"), $(event.target).data("name"), (error, result)->
			if error?
				handleError(error)
		