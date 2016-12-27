TAGT.checkIntroductionAvailability = function(introduction) {
	return introduction.length < TAGT.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') && introduction.length > TAGT.settings.get('UTF8_Long_Names_And_Introduction_MinLength')

};
