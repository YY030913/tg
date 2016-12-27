Template.debateItem.helpers
	fixCordova: (url) ->
		console.log "fixcordova"
		width = $(window).width()
		url = "#{url}?imageMogr2/thumbnail/#{width}/quality/100"
		
		if Meteor.isCordova and url?[0] is '/'
			url = Meteor.absoluteUrl().replace(/\/$/, '') + url
			query = "rc_uid=#{Meteor.userId()}&rc_token=#{Meteor._localStorage.getItem('Meteor.loginToken')}"
			if url.indexOf('?') is -1
				url = url + '?' + query
			else
				url = url + '&' + query

		return url

	_id: ->
		return Template.instance().data._id
	tags: ->
		return Template.instance().data.name
	createtime: ->
		if moment().diff(moment(Template.instance().data.ts), 'days') >= 1
			return moment(Template.instance().data.ts).locale(TAPi18n.getLanguage()).format('YYYY-MM-DD')
		else
			return moment(Template.instance().data.ts).locale(TAPi18n.getLanguage()).fromNow();
	userid: ->
		return Template.instance().data.u._id
	username: ->
		return Template.instance().data.u.username
	imgs: ->
		Template.instance().data.imgs
	txt: ->
		return Template.instance().data.txt.substr(0, 100)

	coverimg: ->
		return Template.instance().data.imgs?[0] || "images/blank.png"

	noPic: ->
		return Template.instance().data.imgs.length == 0

	morePic: ->
		return Template.instance().data.imgs.length > 1

	onePic: ->
		return Template.instance().data.imgs.length == 1

Template.debateItem.onRendered ->
	console.log "debateItem onRendered"
	

Template.typeDebates.onViewRendered = (context) ->
	console.log "debateItem onViewRendered"
	


Template.debateItem.onCreated ->
	console.log "debateItem onCreated"
	@data = Template.currentData()

	Meteor.setTimeout ->
		swiper = new Swiper('.swiper-item-container', {
			slidesPerView: 3,
			paginationClickable: true,
			spaceBetween: 30
		});
	,1000
		
