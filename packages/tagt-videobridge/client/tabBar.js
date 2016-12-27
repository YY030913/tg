Meteor.startup(function() {
	Tracker.autorun(function() {
		if (TAGT.settings.get('Jitsi_Enabled')) {

			// Load from the jitsi meet instance.
			if (typeof JitsiMeetExternalAPI !== undefined) {
				$.getScript('/packages/tagt_videobridge/client/public/external_api.js');
			}

			let tabGroups = ['directmessage', 'privategroup'];

			if (TAGT.settings.get('Jitsi_Enable_Channels')) {
				tabGroups.push('channel');
			}

			TAGT.TabBar.addButton({
				groups: tabGroups,
				id: 'video',
				i18nTitle: 'Video Chat',
				icon: 'icon-videocam',
				iconColor: 'red',
				template: 'videoFlexTab',
				width: 790,
				order: 12
			});

			// Compare current time to call started timeout.  If its past then call is probably over.
			if (Session.get('openedRoom')) {
				let rid = Session.get('openedRoom');

				let room = TAGT.models.Rooms.findOne({_id: rid});
				let currentTime = new Date().getTime();
				let jitsiTimeout = new Date((room && room.jitsiTimeout) || currentTime).getTime();

				if (jitsiTimeout > currentTime) {
					TAGT.TabBar.updateButton('video', { class: 'attention' });
				} else {
					TAGT.TabBar.updateButton('video', { class: '' });
				}

			}
		}
	});
});
