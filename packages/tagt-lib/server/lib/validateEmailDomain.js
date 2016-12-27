const dns = Npm.require('dns');

var emailDomainBlackList = [];
var emailDomainWhiteList = [];
var useDefaultBlackList = false;
var useDNSDomainCheck = false;

TAGT.settings.get('Accounts_BlockedDomainsList', function(key, value) {
	emailDomainBlackList = _.map(value.split(','), (domain) => domain.trim());
});
TAGT.settings.get('Accounts_AllowedDomainsList', function(key, value) {
	emailDomainWhiteList = _.map(value.split(','), (domain) => domain.trim());
});
TAGT.settings.get('Accounts_UseDefaultBlockedDomainsList', function(key, value) {
	useDefaultBlackList = value;
});
TAGT.settings.get('Accounts_UseDNSDomainCheck', function(key, value) {
	useDNSDomainCheck = value;
});

TAGT.validateEmailDomain = function(email) {
	const emailValidation = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
	if (!emailValidation.test(email)) {
		throw new Meteor.Error('error-invalid-email', 'Invalid email ' + email, { function: 'TAGT.validateEmailDomain', email: email });
	}

	const emailDomain = email.substr(email.lastIndexOf('@') + 1);

	// if not in whitelist
	if (emailDomainWhiteList.indexOf(emailDomain) === -1) {
		if (emailDomainBlackList.indexOf(emailDomain) !== -1 || (useDefaultBlackList && TAGT.emailDomainDefaultBlackList.indexOf(emailDomain) !== -1)) {
			throw new Meteor.Error('error-email-domain-blacklisted', 'The email domain is blacklisted', { function: 'TAGT.validateEmailDomain' });
		}
	}

	if (useDNSDomainCheck) {
		try {
			Meteor.wrapAsync(dns.resolveMx)(emailDomain);
		} catch (e) {
			throw new Meteor.Error('error-invalid-domain', 'Invalid domain', { function: 'TAGT.validateEmailDomain' });
		}
	}
};
