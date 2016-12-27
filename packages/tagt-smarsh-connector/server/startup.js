/* globals SyncedCron */
const smarshJobName = 'Smarsh EML Connector';

const _addSmarshSyncedCronJob = _.debounce(Meteor.bindEnvironment(function __addSmarshSyncedCronJobDebounced() {
	if (SyncedCron.nextScheduledAtDate(smarshJobName)) {
		SyncedCron.remove(smarshJobName);
	}

	if (TAGT.settings.get('Smarsh_Enabled') && TAGT.settings.get('Smarsh_Email') !== '' && TAGT.settings.get('From_Email') !== '') {
		SyncedCron.add({
			name: smarshJobName,
			schedule: (parser) => parser.text(TAGT.settings.get('Smarsh_Interval').replace(/_/g, ' ')),
			job: TAGT.smarsh.generateEml
		});
	}
}), 500);

Meteor.startup(() => {
	Meteor.defer(() => {
		_addSmarshSyncedCronJob();

		TAGT.settings.get('Smarsh_Interval', _addSmarshSyncedCronJob);
		TAGT.settings.get('Smarsh_Enabled', _addSmarshSyncedCronJob);
		TAGT.settings.get('Smarsh_Email', _addSmarshSyncedCronJob);
		TAGT.settings.get('From_Email', _addSmarshSyncedCronJob);
	});
});
