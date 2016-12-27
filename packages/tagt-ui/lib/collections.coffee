@ChatMessage = new Meteor.Collection null
@ChatRoom = new Meteor.Collection 'tagt_room'

@CachedChatSubscription = new TAGT.CachedCollection({ name: 'subscriptions', initOnLogin: true })
@ChatSubscription = CachedChatSubscription.collection
@UserRoles = new Mongo.Collection null
@RoomRoles = new Mongo.Collection null
@UserAndRoom = new Meteor.Collection null
@CachedChannelList = new Meteor.Collection null
@CachedUserList = new Meteor.Collection null

@SearchDebatesResult = new Meteor.Collection null
@SearchUsersResult = new Meteor.Collection null
@Tag = new Meteor.Collection 'tagt_tag'
@Ad = new Meteor.Collection 'tagt_ad'
@friendSubscripion = new Meteor.Collection 'tagt_friend_subscription'
@Follow = new Meteor.Collection "tagt_follow" 
@ProfileUsers = new Meteor.Collection "profile-users"

TAGT.models.Users = _.extend {}, TAGT.models.Users, Meteor.users
TAGT.models.Subscriptions = _.extend {}, TAGT.models.Subscriptions, @ChatSubscription
TAGT.models.Rooms = _.extend {}, TAGT.models.Rooms, @ChatRoom
TAGT.models.Messages = _.extend {}, TAGT.models.Messages, @ChatMessage


TAGT.models.Searchs = new Meteor.Collection 'tagt_searchs'
TAGT.models.Tags = _.extend {}, TAGT.models.Tags, @Tag
TAGT.models.Ads = _.extend {}, TAGT.models.Ads, @Ad
TAGT.models.Follow = _.extend {}, @Follow