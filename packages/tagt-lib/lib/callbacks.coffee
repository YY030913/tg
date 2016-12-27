# https://github.com/TelescopeJS/Telescope/blob/master/packages/telescope-lib/lib/callbacks.js

###
# Callback hooks provide an easy way to add extra steps to common operations.
# @namespace TAGT.callbacks
###
TAGT.callbacks = {}

TAGT.callbacks.showTime = false

###
# Callback priorities
###
TAGT.callbacks.priority =
	HIGH: -1000
	MEDIUM: 0
	LOW: 1000

###
# Add a callback function to a hook
# @param {String} hook - The name of the hook
# @param {Function} callback - The callback function
###
TAGT.callbacks.add = (hook, callback, priority, id) ->
	# if callback array doesn't exist yet, initialize it
	priority ?= TAGT.callbacks.priority.MEDIUM
	unless _.isNumber priority
		priority = TAGT.callbacks.priority.MEDIUM
	callback.priority = priority
	callback.id = id or Random.id()
	TAGT.callbacks[hook] ?= []

	if TAGT.callbacks.showTime is true
		err = new Error
		callback.stack = err.stack

	# Avoid adding the same callback twice
	for cb in TAGT.callbacks[hook]
		if cb.id is callback.id
			return

	TAGT.callbacks[hook].push callback
	return

###
# Remove a callback from a hook
# @param {string} hook - The name of the hook
# @param {string} id - The callback's id
###

TAGT.callbacks.remove = (hookName, id) ->
	TAGT.callbacks[hookName] = _.reject TAGT.callbacks[hookName], (callback) ->
		callback.id is id
	return

###
# Successively run all of a hook's callbacks on an item
# @param {String} hook - The name of the hook
# @param {Object} item - The post, comment, modifier, etc. on which to run the callbacks
# @param {Object} [constant] - An optional constant that will be passed along to each callback
# @returns {Object} Returns the item after it's been through all the callbacks for this hook
###

TAGT.callbacks.run = (hook, item, constant) ->
	callbacks = TAGT.callbacks[hook]
	if !!callbacks?.length
		# if the hook exists, and contains callbacks to run
		_.sortBy(callbacks, (callback) -> return callback.priority or TAGT.callbacks.priority.MEDIUM).reduce (result, callback) ->
			# console.log(callback.name);
			if TAGT.callbacks.showTime is true
				time = Date.now()

			callbackResult = callback result, constant

			if TAGT.callbacks.showTime is true
				console.log hook, Date.now() - time
				console.log callback.stack.split('\n')[2]

			return callbackResult
		, item
	else
		# else, just return the item unchanged
		item

###
# Successively run all of a hook's callbacks on an item, in async mode (only works on server)
# @param {String} hook - The name of the hook
# @param {Object} item - The post, comment, modifier, etc. on which to run the callbacks
# @param {Object} [constant] - An optional constant that will be passed along to each callback
###

TAGT.callbacks.runAsync = (hook, item, constant) ->
	callbacks = TAGT.callbacks[hook]
	if Meteor.isServer and !!callbacks?.length
		# use defer to avoid holding up client
		Meteor.defer ->
			# run all post submit server callbacks on post object successively
			_.sortBy(callbacks, (callback) -> return callback.priority or TAGT.callbacks.priority.MEDIUM).forEach (callback) ->
				# console.log(callback.name);
				callback item, constant
				return
			return
	else
		return item
	return
