TAGT.Migrations.add({
	version: 48,
	up: function() {
		if (TAGT && TAGT.models && TAGT.models.Settings) {

			var RocketBot_Enabled = TAGT.models.Settings.findOne({
				_id: 'RocketBot_Enabled'
			});
			if (RocketBot_Enabled) {
				TAGT.models.Settings.remove({
					_id: 'RocketBot_Enabled'
				});
				TAGT.models.Settings.upsert({
					_id: 'InternalHubot_Enabled'
				}, {
					$set: {
						value: RocketBot_Enabled.value
					}
				});
			}

			var RocketBot_Name = TAGT.models.Settings.findOne({
				_id: 'RocketBot_Name'
			});
			if (RocketBot_Name) {
				TAGT.models.Settings.remove({
					_id: 'RocketBot_Name'
				});
				TAGT.models.Settings.upsert({
					_id: 'InternalHubot_Username'
				}, {
					$set: {
						value: RocketBot_Name.value
					}
				});
			}

		}
	}
});
