Meteor.methods
  openRoom: (rid) ->

    check rid, String

    if not Meteor.userId()
      throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'openRoom' }

    TAGT.models.Subscriptions.openByRoomIdAndUserId rid, Meteor.userId()
