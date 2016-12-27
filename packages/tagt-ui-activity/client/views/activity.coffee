Template.activity.helpers
	activities: ->
		if FlowRouter.current().params?.uid?
			return TAGT.models.Activity.find({userId: FlowRouter.current().params.uid});
		else
			return TAGT.models.Activity.find {userId: Meteor.userId()}

	createTime: ->
		return moment(this.ts).locale(TAPi18n.getLanguage()).format('L LT')

Template.activity.onCreated ->


Template.activity.onRendered ->
	###
	Meteor.call("getActivity", FlowRouter.current().params.slug, (error, result)->
		if error?
			toastr.error t(error.message)
		else 
			TAGT.models.Activity.upsert {_id: FlowRouter.current().params.slug}, result
			self.activity.set(result);
	);
	###


	timelineBlocks = $('.cd-timeline-block')
	offset = 0.8;

	hideBlocks(timelineBlocks, offset);

	$(window).on('scroll', ->
		if (!window.requestAnimationFrame)
			setTimeout(-> 
				showBlocks(timelineBlocks, offset); 
			, 100)
		else 
			window.requestAnimationFrame(-> 
				showBlocks(timelineBlocks, offset); 
			);
	);

hideBlocks = (blocks, offset) ->
	blocks.each( -> 
		( $(this).offset().top > $(window).scrollTop()+$(window).height()*offset ) && $(this).find('.cd-timeline-img, .cd-timeline-content').addClass('is-hidden');
	);

showBlocks = (blocks, offset) ->
	blocks.each( ->
		( $(this).offset().top <= $(window).scrollTop()+$(window).height()*offset && $(this).find('.cd-timeline-img').hasClass('is-hidden') ) && $(this).find('.cd-timeline-img, .cd-timeline-content').removeClass('is-hidden').addClass('bounce-in');
	);