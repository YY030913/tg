# BaiduyunSpider
包含百度云网盘爬虫、网站前后端、搜索，整套服务。http://www.githubs.cn/project/16085

![爱百应](screenshot1.png)

![爱百应](screenshot2.png)

## 技术栈

####loading
css server inject

####LOGIN , USERNAME [set avatar from service](#getAvatarSuggestion #setAvatarFromService)
layout, header, form, service, bottom
view     
        ui-login -> html
controller
        ui-login -> coffee

db 
        lib

flow:
``ui/lib/cordova/service-login.coffee

	click .external-login

	cordova
		Meteor.loginWith[service]]Cordova

	OAUTH,ACCOUNT-BASE,ACCOUNT

	server/lib/cordova/Accounts.registerLoginHandler
	account-oauth(updateOrCreateUserFromExternalService)


####MESSAGE
view
streamer






## 演示站点

* [爱百应搜索](http://pan.ibying.com)



## 附言

>  xxxxx
>
>  @xxx



__TODO__

- [ ] 分布式爬虫
- [ ] 爬虫IP代理
- [ ] Web 控制面板
- [ ] 死链检测

近期__TODO__
- [ ] 重构爬虫 => 采用Node.js
- [ ] 使用 elasticsearch 搜索引擎


## 讨论交流

有任何疑问，请在 [github 中文社区](http://www.githubs.cn/topic/118) 发帖。

[安装教程](http://www.githubs.cn/post/22)

## License

GPL


