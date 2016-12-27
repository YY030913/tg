Meteor.startup(function() {
	Tracker.autorun(function() {
		var user, utcOffset;
		user = Meteor.user();
		
		if (user && user.statusConnection === 'online') {
			userLocation = user.shortCountry
			if (userLocation==null) {
				var lng = window.navigator.userLanguage || window.navigator.language || 'en';
				var re = /([a-z]{2}-)([a-z]{2})/;
				if (re.test(lng)) {
					lng = lng.replace(re, function() {
						var match, parts;
						match = arguments[0], parts = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
						return parts[0] + parts[1].toUpperCase();
					});
				}
				loc = lng.split("-");
				Meteor.call('setShortCountry', loc[loc.length-1].toLowerCase());
			}
			
		}
	});
});
