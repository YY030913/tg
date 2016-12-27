/*
	VIEWPORT BUG FIX
	iOS viewport scaling bug fix, by @mathias, @cheeaun and @jdalton
*/

; (function(e) {
	function o() {
		s.content = "width=device-width,minimum-scale=" + i[0] + ",maximum-scale=" + i[1];
		e.removeEventListener(n, o, true)
	}
	var t = "addEventListener",
		n = "gesturestart",
		r = "querySelectorAll",
		i = [1, 1],
		s = r in e ? e[r]("meta[name=viewport]") : [];
	if ((s = s[s.length - 1]) && t in e) {
		o();
		i = [.25, 1.6];
		e[t](n, o, true)
	}
})(document);