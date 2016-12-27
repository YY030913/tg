TAGT.Score = {};
TAGT.Score.utils = {};


TAGT.Score.utils.minScore = -100;
TAGT.Score.utils.registerScore = 100;
TAGT.Score.utils.debateCreateScore = 10;
TAGT.Score.utils.loginScore = 1;
TAGT.Score.utils.addFollow = 0;
TAGT.Score.utils.sendMessage = 0;
TAGT.Score.utils.debateJoinScore = 0;
TAGT.Score.utils.roomJoinScore = 0; 


TAGT.Score.utils.MaxCount = 102400;

###
icon
operator
title
content
###

TAGT.Score.utils.add = (href, icon, operator) ->
	"icon": icon
	"operator": operator
	"href": href


TAGT.Score.utils.canCreateDebateCount = (score) ->
	if score <= 10000
		return 1
	else if score <= 50000 && score > 10000
		return 5
	else if score <= 100000 && score > 50000
		return 20
	else 
		return TAGT.Score.utils.MaxCount

TAGT.Score.utils.canOptionMsgCount = (score) ->
	if score <= 1000
		return 50
	else if score <= 5000 && score > 1000
		return 500
	else if score <= 100000 && score > 5000
		return 5000
	else 
		return TAGT.Score.utils.MaxCount

TAGT.Score.utils.canTipoffCount = (score) ->
	if score <= 1000
		return 3
	else if score <= 5000 && score > 1000
		return 30
	else if score <= 100000 && score > 5000
		return 300
	else 
		return TAGT.Score.utils.MaxCount