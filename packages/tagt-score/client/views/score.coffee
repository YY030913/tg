Template.score.helpers
	scores: ->
		if FlowRouter.current().params?.uid?
			return TAGT.models.Score.find({userId: FlowRouter.current().params.uid});
		else
			return TAGT.models.Score.find {userId: Meteor.userId()}

	createTime: ->
		return moment(this.ts).locale(TAPi18n.getLanguage()).format('L LT')

	sumScore: ->
		if FlowRouter.current().params?.uid?
			return TAGT.models.Users.findOne({userId: FlowRouter.current().params.uid}).score;
		else
			Meteor.user().score

	LoginScore: ->
		uid = FlowRouter.current().params?.uid? || Meteor.user()
		cursor = TAGT.models.Score.find({userId: uid, operator: 'Login'}, {fields: {score: 1}})
		sum = 0;
		cursor.forEach((doc) ->
			console.log doc.score
			sum = sum + doc.score
		);
		return sum;

	debateScore: ->
		uid = FlowRouter.current().params?.uid? || Meteor.user()
		cursor = TAGT.models.Score.find({userId: uid, operator: 'Create_Debae'}, fields: {score: 1});
		sum = 0;
		cursor.forEach((doc) ->
			sum = sum + doc.score
		);
		return sum;


	registerDate: ->
		uid = FlowRouter.current().params?.uid? || Meteor.user()
		return moment(TAGT.models.Score.findOne({userId: uid, operator: 'Register'}, {fields: {ts: 1}})?.ts).locale(TAPi18n.getLanguage()).format('L LT');

	firstSpeakDate: ->
		uid = FlowRouter.current().params?.uid? || Meteor.user()
		if TAGT.models.Score.findOne({userId: uid, operator: 'Send_Message'}, {fields: {ts: 1}})?
			return moment(TAGT.models.Score.findOne({userId: uid, operator: 'Send_Message'}, {fields: {ts: 1}})?.ts).locale(TAPi18n.getLanguage()).format('L LT') 
		else
			return false;

	hundredSpeakDate: ->
		uid = FlowRouter.current().params?.uid? || Meteor.user()
		if TAGT.models.Score.findOne({userId: uid, operator: 'Send_Message'}, {limit: 1, skip: 99, sort: ts: 1, fields: {ts: 1}})?
			return moment(TAGT.models.Score.findOne({userId: uid, operator: 'Send_Message'}, {limit: 1, skip: 99, sort: ts: 1, fields: {ts: 1}})?.ts).locale(TAPi18n.getLanguage()).format('L LT')
		else
			false;

Template.score.onCreated ->
	@score = new ReactiveVar Object

Template.score.onRendered ->
	self = this
	Template.instance().score.set({result: true});
	###
	Meteor.call("getScore", FlowRouter.current().params.slug, (error, result)->
		if error?
			toastr.error t(error.message)
		else 
			TAGT.models.Score.upsert {_id: FlowRouter.current().params.slug}, result
			self.score.set(result);
	);
	###