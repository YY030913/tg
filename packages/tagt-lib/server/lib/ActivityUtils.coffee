TAGT.Activity = {};
TAGT.Activity.utils = {};

###
icon
operator
title
content
###

TAGT.Activity.utils.add = (title, content, icon, operator, href) ->
  "icon": icon
  "operator": operator
  "title": title
  "content": content
  "href": href