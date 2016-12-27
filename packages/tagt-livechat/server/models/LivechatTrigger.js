/**
 * Livechat Trigger model
 */
class LivechatTrigger extends TAGT.models._Base {
	constructor() {
		super();
		this._initModel('livechat_trigger');
	}

	// FIND
	save(data) {
		const trigger = this.findOne();

		if (trigger) {
			return this.update({ _id: trigger._id }, { $set: data });
		} else {
			return this.insert(data);
		}
	}

	removeAll() {
		this.remove({});
	}
}

TAGT.models.LivechatTrigger = new LivechatTrigger();
