@parentCall = (method, args = []) ->
	data =
		src: 'tagt'
		fn: method
		args: args

	window.parent.postMessage data, '*'
