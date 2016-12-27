isSubscribed =  ->
	return FlowRouter.subsReady('debate')

Template.debateCateConfirm.helpers
	username: ->
		return TAGT.models.Debates.findOne(FlowRouter.current().params.slug).u.username || 'load'
	t: ->
		return TAGT.models.Debates.findOne(FlowRouter.current().params.slug).ts || 'load'
	tags: ->
		return ['hello', 'world']
	htmlBody: ->
		return TAGT.models.Debates.findOne(FlowRouter.current().params.slug).htmlBody || 'load'
	isSub: ->
		return isSubscribed();

Template.debateCateConfirm.onCreated ->
	@debate = new ReactiveVar Object

Template.debateCateConfirm.onRendered ->
	self = this
	Template.instance().debate.set({result: true});
	Meteor.call("getDebate", FlowRouter.current().params.slug, (error, result)->
		if error?
			toastr.error t(error.message)
		else 
			TAGT.models.Debates.upsert {_id: FlowRouter.current().params.slug}, result
			self.debate.set(result);
	);

Template.debateCateConfirm.onDestroyed ->
	console.log("onDestroyed")

Template.debateCateConfirm.events
	'click #reward,#debate,#fuck': (event, instance)->
		console.log $(event.currentTarget).attr('id')
		$(event.currentTarget).addClass('cate-confirm')
		$(".confirm-content").each( ->
			if $(this).data("id") == $(event.currentTarget).attr('id')
				$(this).addClass('show-confirm-content')
			else 
				console.log $(this).data("id")
				$(this).addClass('hide-cate')
		)

