TAGT.callbacks.add('livechat.offlineMessage', (data) => {
	if (!TAGT.settings.get('Livechat_webhook_on_offline_msg')) {
		return data;
	}

	let postData = {
		type: 'LivechatOfflineMessage',
		sentAt: new Date(),
		visitor: {
			name: data.name,
			email: data.email
		},
		message: data.message
	};

	TAGT.Livechat.sendRequest(postData);
});
