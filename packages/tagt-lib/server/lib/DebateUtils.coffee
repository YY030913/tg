TAGT.Debate = {};

TAGT.Debate.readWeight = 0.1
TAGT.Debate.shareWeight = 0.5
TAGT.Debate.favoriteWeight = 0.2
TAGT.Debate.commentWeight = 0.2


TAGT.Debate.utils = {};

###
icon
operator
title
content
###

TAGT.Debate.utils.addDebate = (debate, icon, operator) ->
  "icon": icon
  "operator": operator
  "title": debate.name
  "content": debate.abstractHtml
