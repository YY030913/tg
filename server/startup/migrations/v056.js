TAGT.Migrations.add({
	version: 56,
	up: function() {
		TAGT.models.Messages.find({ _id: /\./ }).forEach(function(message) {
			var oldId = message._id;
			message._id = message._id.replace(/(.*)\.S?(.*)/, 'slack-$1-$2');
			TAGT.models.Messages.insert(message);
			TAGT.models.Messages.remove({ _id: oldId });
		});
	}
});
