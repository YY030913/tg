Template.adBanner.helpers
	fromEmail: ->
		return TAGT.settings.get 'From_Email'

	ads: ->
		return TAGT.models.Ads.find()

	unreadData: ->
		return @unreadData
	hasMore: ->
		return @hasMore
	isLoading: ->
		return @isLoading


Template.adBanner.events


Template.adBanner.onRendered ->
	swiper = new Swiper('.swiper-ad-container', {
		pagination: '.swiper-ad-pagination',
		paginationClickable: true,
		centeredSlides: true,
		autoplay: 2500,
		loop: true,
		autoplayDisableOnInteraction: false
	});

Template.adBanner.onCreated ->
	console.log "adBanner.onCreated"
	@unreadCount = new ReactiveVar 0
	@atTop = true

Template.adBanner.onDestroyed ->
	DebatesManager.clear this.data._id