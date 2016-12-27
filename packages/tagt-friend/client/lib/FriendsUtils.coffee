TAGT.Friends = {};
TAGT.Friends.utils = {};

###
icon
operator
title
content
###

TAGT.Friends.utils.trans = (array) ->


compare = (a, b)->
	if (a == b) {
		return 0;
	}
	if a.length == 0
		return 1

	if (b.length == 0)
		return -1

	count = a.length > b.length ? b.length : a.length
	i = 0
	for i in count

		var au = this.getOrderedUnicode(a[i]);
		var bu = this.getOrderedUnicode(b[i]);

		if (au > bu) 
			return 1;
		else if (au < bu) 
			return -1;
		i++

	return a.length > b.length ? 1 : -1;


getOrderedUnicode = (char)->

	originalUnicode = char.charCodeAt();

	if (originalUnicode >= 0x4E00 && originalUnicode <= 0x9FA5) 

		index = this.db.indexOf(char);

		if (index > -1) 
			return index + 0x4E00;

	return originalUnicode;

