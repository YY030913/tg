Template.livechatInstallation.helpers({
	script() {
		let siteUrl = s.rtrim(TAGT.settings.get('Site_Url'), '/');

		return `<!-- Start of TalkGet Livechat Script -->
<script type="text/javascript">
(function(w, d, s, u) {
	w.TAGT = function(c) { w.TAGT._.push(c) }; w.TAGT._ = []; w.TAGT.url = u;
	var h = d.getElementsByTagName(s)[0], j = d.createElement(s);
	j.async = true; j.src = '${siteUrl}/packages/tagt_livechat/assets/rocket-livechat.js';
	h.parentNode.insertBefore(j, h);
})(window, document, 'script', '${siteUrl}/livechat');
</script>
<!-- End of TalkGet Livechat Script -->`;
	}
});
