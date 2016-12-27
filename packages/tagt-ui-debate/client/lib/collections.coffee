@Debate = new Meteor.Collection "tagt_debate_pub" 
@Debates = new Meteor.Collection null
@DebateSubscription = new Meteor.Collection 'tagt_debate_subscription'

TAGT.models.Debate = _.extend {}, @Debate
TAGT.models.Debates = _.extend {}, @Debates