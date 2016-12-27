Meteor.startup(function() {
	Meteor.autorun(function() {
		let CustomTranslations = TAGT.settings.get('Custom_Translations');
		if (typeof CustomTranslations === 'string' && CustomTranslations.trim() !== '') {
			try {
				CustomTranslations = JSON.parse(CustomTranslations);

				for (const lang in CustomTranslations) {
					if (CustomTranslations.hasOwnProperty(lang)) {
						const translations = CustomTranslations[lang];
						TAPi18next.addResourceBundle(lang, 'project', translations);
					}
				}
			} catch (e) {
				console.error('Invalid setting Custom_Translations', e);
			}
		}
	});
});
