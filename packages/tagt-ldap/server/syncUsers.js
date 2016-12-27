/* globals sync */

Meteor.methods({
	ldap_sync_users: function() {
		const user = Meteor.user();
		if (!user) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'ldap_sync_users' });
		}

		if (!TAGT.authz.hasRole(user._id, 'admin')) {
			throw new Meteor.Error('error-not-authorized', 'Not authorized', { method: 'ldap_sync_users' });
		}

		if (TAGT.settings.get('LDAP_Enable') !== true) {
			throw new Meteor.Error('LDAP_disabled');
		}

		const result = sync();

		if (result === true) {
			return {
				message: 'Sync_success',
				params: []
			};
		}

		throw result;
	}
});
