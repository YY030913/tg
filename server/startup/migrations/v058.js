TAGT.Migrations.add({
	version: 58,
	up: function() {
		TAGT.models.Settings.update({ _id: 'Push_gateway', value: 'https://caoliao.net.cn' }, {
			$set: {
				value: 'https://gateway.talk.get',
				packageValue: 'https://gateway.talk.get'
			}
		});
	}
});
