TAGT.AdminBox.addOption({
	href: 'emoji-custom',
	i18nLabel: 'Custom_Emoji',
	permissionGranted() {
		return TAGT.authz.hasAtLeastOnePermission(['manage-emoji']);
	}
});
