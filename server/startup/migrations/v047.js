TAGT.Migrations.add({
	version: 47,
	up: function() {
		if (TAGT && TAGT.models && TAGT.models.Settings) {
			var autolinkerUrls = TAGT.models.Settings.findOne({ _id: 'AutoLinker_Urls' });
			if (autolinkerUrls) {
				TAGT.models.Settings.remove({ _id: 'AutoLinker_Urls' });
				TAGT.models.Settings.upsert({ _id: 'AutoLinker_Urls_Scheme' }, {
					$set: {
						value: autolinkerUrls.value ? true : false,
						i18nLabel: 'AutoLinker_Urls_Scheme'
					}
				});
				TAGT.models.Settings.upsert({ _id: 'AutoLinker_Urls_www' }, {
					$set: {
						value: autolinkerUrls.value ? true : false,
						i18nLabel: 'AutoLinker_Urls_www'
					}
				});
				TAGT.models.Settings.upsert({ _id: 'AutoLinker_Urls_TLD' }, {
					$set: {
						value: autolinkerUrls.value ? true : false,
						i18nLabel: 'AutoLinker_Urls_TLD'
					}
				});
			}
		}
	}
});
