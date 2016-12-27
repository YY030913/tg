/* globals TAGT */
class Twilio {
	constructor() {
		this.accountSid = TAGT.settings.get('SMS_Twilio_Account_SID');
		this.authToken = TAGT.settings.get('SMS_Twilio_authToken');
	}
	parse(data) {
		return {
			from: data.From,
			to: data.To,
			body: data.Body,

			extra: {
				toCountry: data.ToCountry,
				toState: data.ToState,
				toCity: data.ToCity,
				toZip: data.ToZip,
				fromCountry: data.FromCountry,
				fromState: data.FromState,
				fromCity: data.FromCity,
				fromZip: data.FromZip
			}
		};
	}
	send(fromNumber, toNumber, message) {
		var client = Npm.require('twilio')(this.accountSid, this.authToken);

		client.messages.create({
			to: toNumber,
			from: fromNumber,
			body: message
		});
	}
	response(/* message */) {
		return {
			headers: {
				'Content-Type': 'text/xml'
			},
			body: '<Response></Response>'
		};
	}
	error(error) {
		let message = '';
		if (error.reason) {
			message = `<Message>${error.reason}</Message>`;
		}
		return {
			headers: {
				'Content-Type': 'text/xml'
			},
			body: `<Response>${message}</Response>`
		};
	}
}

TAGT.SMS.registerService('twilio', Twilio);
