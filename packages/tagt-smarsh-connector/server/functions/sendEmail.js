/* globals UploadFS */
//Expects the following details:
// {
// 	body: '<table>',
// 	subject: 'TalkGet, 17 Users, 24 Messages, 1 File, 799504 Minutes, in #random',
//  files: ['i3nc9l3mn']
// }

TAGT.smarsh.sendEmail = (data) => {
	const attachments = [];

	if (data.files.length > 0) {
		_.each(data.files, (fileId) => {
			const file = TAGT.models.Uploads.findOneById(fileId);
			if (file.store === 'tagt_uploads' || file.store === 'fileSystem') {
				const rs = UploadFS.getStore(file.store).getReadStream(fileId, file);
				attachments.push({
					filename: file.name,
					streamSource: rs
				});
			}
		});
	}

	Email.send({
		to: TAGT.settings.get('Smarsh_Email'),
		from: TAGT.settings.get('From_Email'),
		subject: data.subject,
		html: data.body,
		attachments: attachments
	});
};
