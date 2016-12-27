TAGT.Layout = new (class TAGTLayout {
	constructor() {
		Tracker.autorun(() => {
			this.layout = FlowRouter.getQueryParam('layout');
		});
	}

	isEmbedded() {
		return this.layout === 'embedded';
	}
});
