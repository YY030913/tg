TAGT.Migrations.add({
	version: 57,
	up: function() {
		TAGT.models.Messages.find({ _id: /slack-([a-zA-Z0-9]+)S([0-9]+-[0-9]+)/ }).forEach(function(message) {
			var oldId = message._id;
			message._id = message._id.replace(/slack-([a-zA-Z0-9]+)S([0-9]+-[0-9]+)/, 'slack-$1-$2');
			TAGT.models.Messages.insert(message);
			TAGT.models.Messages.remove({ _id: oldId });
		});

		TAGT.models.Messages.find({ _id: /slack-slack/ }).forEach(function(message) {
			var oldId = message._id;
			message._id = message._id.replace('slack-slack', 'slack');
			TAGT.models.Messages.insert(message);
			TAGT.models.Messages.remove({ _id: oldId });
		});

		TAGT.models.Messages.find({ _id: /\./ }).forEach(function(message) {
			var oldId = message._id;
			message._id = message._id.replace(/(.*)\.?S(.*)/, 'slack-$1-$2');
			message._id = message._id.replace(/\./g, '-');
			TAGT.models.Messages.remove({ _id: message._id });
			TAGT.models.Messages.insert(message);
			TAGT.models.Messages.remove({ _id: oldId });
		});
	}
});
