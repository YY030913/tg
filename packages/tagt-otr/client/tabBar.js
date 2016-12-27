Meteor.startup(function() {
	Tracker.autorun(function() {
		if (TAGT.settings.get('OTR_Enable') && window.crypto) {
			TAGT.OTR.crypto = window.crypto.subtle || window.crypto.webkitSubtle;
			TAGT.OTR.enabled.set(true);
			TAGT.TabBar.addButton({
				groups: ['directmessage'],
				id: 'otr',
				i18nTitle: 'OTR',
				icon: 'icon-key',
				template: 'otrFlexTab',
				order: 11
			});
		} else {
			TAGT.OTR.enabled.set(false);
			TAGT.TabBar.removeButton('otr');
		}
	});
});
