Meteor.methods
	'robot.modelCall': (model, method, args) ->

		check model, String
		check method, String

		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'robot.modelCall' }

		unless TAGT.authz.hasRole Meteor.userId(), 'robot'
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'robot.modelCall' }

		unless _.isFunction TAGT.models[model]?[method]
			throw new Meteor.Error 'error-invalid-method', 'Invalid method', { method: 'robot.modelCall' }

		call = TAGT.models[model][method].apply(TAGT.models[model], args)

		if call?.fetch?()?
			return call.fetch()
		else
			return call
