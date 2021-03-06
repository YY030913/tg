TAGT.actionLinks.register('joinJitsiCall', function(/*message, params*/) {
	if (Session.get('openedRoom')) {
		let rid = Session.get('openedRoom');

		let room = TAGT.models.Rooms.findOne({_id: rid});
		let currentTime = new Date().getTime();
		let jitsiTimeout = new Date((room && room.jitsiTimeout) || currentTime).getTime();

		if (jitsiTimeout > currentTime) {
			TAGT.TabBar.setTemplate('videoFlexTab');

			// calling openFlex should set the width instead of having to do this.
			$('.flex-tab').css('max-width', '790px');

			TAGT.TabBar.openFlex();
		} else {
			toastr.info(TAPi18n.__('Call Already Ended', ''));
		}
	}
});
