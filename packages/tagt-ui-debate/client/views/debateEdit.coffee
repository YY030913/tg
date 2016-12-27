isSubscribed =  ->
	return FlowRouter.subsReady('debate')

md = new MobileDetect(window.navigator.userAgent);

Template.debateEdit.helpers
	isSubscribed: ->
		return isSubscribed()
	pagetitle: ->
		return TAGT.models.Debate.findOne(FlowRouter.current().params.slug)?.name or TAPi18n.__("Debate_Create")
	invalidEdit: ->
		return Meteor.userId() != TAGT.models.Debate.findOne(FlowRouter.current().params.slug)?.u._id
	name: ->
		name = TAGT.models.Debate.findOne(FlowRouter.current().params.slug)?.name
		Template.instance().name.set(name);
		return name
	flexOpened: ->
		return 'opened' if TAGT.TabBar.isFlexOpen()
	arrowPosition: ->
		return 'left' unless TAGT.TabBar.isFlexOpen()
	mobile: ->
		return Meteor.isCordova || md.mobile()?

	fileUploadAllowedMediaTypes: ->
		return TAGT.settings.get('FileUpload_MediaTypeWhiteList')

	cordova: ->
		return Meteor.isCordova || md.mobile()


Template.debateEdit.onRendered ->

	if Meteor.isCordova || md.mobile()?
		if TAGT.settings.get('FileUpload_Storage_Type') == "QiNiu"

			$("input[type=file]").attr("disabled", "disabled")

			btnId = 'upload' + Math.random().toString().slice(2);
			$(".icon-wangEditor-m-picture").attr('id', btnId);

			containerId = 'upload' + Math.random().toString().slice(2);
			$(".add-img").attr('id', containerId);

			uploadHandler = new Qiniu.uploader({
				runtimes: 'html5,flash,html4',
				browse_button: btnId,
				container: containerId,
				uptoken_url: '/api/uptoken',
				domain: 'http://o8rnbrutf.bkt.clouddn.com/',
				max_file_size: '20mb',
				flash_swf_url: '../js/plupload/Moxie.swf',
				filters: {
					mime_types: [
						{ title: "图片文件,语音文件", extensions: "jpg,gif,png,bmp,wav" }
					]
				},
				max_retries: 3,
				dragdrop: true,
				chunk_size: '2mb',
				auto_start: true, 
				init: {
					'FilesAdded': (up, files) ->
						plupload.each(files, (file) ->
							console.log file
						);
					,
					'BeforeUpload': (up, file) ->
						file.name = "#{Meteor.userId()}#{(new Date()).getTime()}#{file.name}"
					,
					'UploadProgress': (up, file) ->
						console.log("UploadProgress")

						chunk_size = plupload.parseSize(this.getOption('chunk_size'));

						console.log(file.percent + "%", file.speed, chunk_size);
					,
					'FileUploaded': (up, file, info) ->
						console.log("FileUploaded")
						domain = up.getOption('domain');
						res = $.parseJSON(info);
						sourceLink = domain + res.key;
						console.log(sourceLink)
						fileUrl = sourceLink
						console.log(file)
						attachment = {
							title: "File Uploaded: #{file.name}",
							title_link: sourceLink,
							title_link_download: true
						};

						if /^image\/.+/.test(file.type) 
							attachment.image_url = fileUrl;
							attachment.image_type = file.type;
							attachment.image_size = file.size;
							if file.identify && file.identify.size
								attachment.image_dimensions = file.identify.size;

							width = $(window).width() - 50;

							fileUrl += "?imageMogr2/thumbnail/#{width}/quality/100"

							fileElem = $('<img src="' + fileUrl + '"/>');



						else if /^audio\/.+/.test(file.type)
							attachment.audio_url = fileUrl;
							attachment.audio_type = file.type;
							attachment.audio_size = file.size;

							fileElem = $('<audio controls><source src="' + fileUrl + '" type="' + file.type + '"></source></audio>');

						else if /^video\/.+/.test(file.type)
							attachment.video_url = fileUrl;
							attachment.video_type = file.type;
							attachment.video_size = file.size;
							
							fileElem = $('<video controls><source src="' + fileUrl + '" type="' + file.type + '"></source></video>');


						$(".wangEditor-mobile-txt").append(fileElem)
						localStorage.setItem("debateContent", self.editor.get().$txt.html())
						
					'Key': (up, file) ->
						if file.name.lastIndexOf('.') >= 0
							extname = file.name.slice(file.name.lastIndexOf('.') - file.name.length)
						else
							extname = '';

						if extname == '' && file.type.indexOf('/') >= 0
							extname = '.' + file.type.split('/')[1];
						
						now = new Date()
						key = "debateIMG-" + Meteor.userId() + "-" + now.getTime() + extname
					,
					'Error': (up, err, errTip) ->
						toastr.error(t(err.message))
					,
					'UploadComplete': (up, files) ->
						console.log("UploadComplete")
					
				}
			});
	
	
Template.debateEdit.onCreated ->
	@editor = new ReactiveVar null
	@name = new ReactiveVar ""
	@save = new ReactiveVar false
	@hasEditor = new ReactiveVar false
	@debateType = new ReactiveVar null
	self = @

	@createDebate = () =>
		if self.editor?.get()?
			save = self.save.get()
			
			imgs = [];
			if localStorage.getItem("debateContent")?
				imgs = TAGT.utils.stripImgSrcs TAGT.utils.extendRemoveImgSrcs localStorage.getItem("debateContent")
			

			temp = {
				_id: FlowRouter.current().params.slug
				name: self.name.get()
				content: localStorage.getItem("debateContent")
				debateType: self.debateType.get()
				members: []
				save: save
				imgs: imgs
			}

			if save == true
				console.log "save"
				opts = {
					lines: 13, 
					length: 11,
					width: 5, 
					radius: 17,
					corners: 1,
					rotate: 0, 
					color: '#FFF',
					speed: 1, 
					trail: 60, 
					shadow: false,
					hwaccel: false, 
					className: 'spinner',
					zIndex: 2e9,
					top: 'auto',
					left: 'auto'
				};
				target = document.createElement("div");
				document.body.appendChild(target);
				spinner = new Spinner(opts).spin(target);
				overlay = window.iosOverlay({
					text: "Loading",
					spinner: spinner
				});

				

				Meteor.call "createDebate", temp, (error, result)->

					$(".icon-ok-a").removeClass('load-circle');

					overlay?.hide()
					if error?
						handleError(error)
					else
						if save is true
							localStorage.setItem("debateContent", "");
							if result?
								FlowRouter.go("/debate/"+result);
							else
								toastr.error TAPi18n.__("__debate_not_exists__");
								FlowRouter.go("/openFlag/debates/News");

	currentTracker = Tracker.autorun (c) ->
		console.log "Tracker.autorun"

		if isSubscribed() && TAGT.models.Debate.find(FlowRouter.current().params.slug).count() == 0
			currentTracker = undefined
			c.stop()
			FlowRouter.go("home");



	width = $(window).width()
	
	if TAGT.models.Debate.findOne(FlowRouter.current().params.slug).save
		Session.set("debateType", TAGT.models.Debate.findOne(FlowRouter.current().params.slug).debateType)
	
	md = new MobileDetect(window.navigator.userAgent);


	initInterval = Meteor.setInterval ->
		if $("#edit-content").length > 0 && isSubscribed() && TAGT.models.Debate.findOne(FlowRouter.current().params.slug)?
			Meteor.clearInterval initInterval
			currentTracker = undefined
			c.stop()
			if Meteor.isCordova || md.mobile()?
				editorobj = new window.___E('edit-content');
				editorobj.config.menus = [
					'head',
					'bold',
					'color',
					'quote',
					'list',
					'img',
					'check'
				]
				editorobj.config.loadingImg = '/images/logo/loading.gif';
				editorobj.config.uploadImgUrl = '/uploadDebateImg';
				editorobj.config.uploadTimeout = 20 * 1000;
				editorobj.init();
				#console.log "wang init",TAGT.models.Debate.findOne(FlowRouter.current().params.slug)?.htmlBody
				editorobj.$txt.html(TAGT.utils.extendImgSrcs(TAGT.models.Debate.findOne(FlowRouter.current().params.slug)?.htmlBody || localStorage.getItem("debateContent") || "", "?imageMogr2/thumbnail/#{width}/quality/100"))
				self.editor.set(editorobj)
				self.hasEditor.set(true)
			else
				editorobj = new wangEditor('edit-content');
				editorobj.config.customUpload = true;
				editorobj.config.customUploadInit =->
					editor = this;
					btnId = editor.customUploadBtnId;
					containerId = editor.customUploadContainerId;
					uploader = Qiniu.uploader(
						runtimes: 'html5,flash,html4',
						browse_button: btnId,
						uptoken_url: '/api/uptoken',
						domain: 'http://o8rnbrutf.bkt.clouddn.com/',
						container: containerId,
						max_file_size: '100mb',
						flash_swf_url: '../js/plupload/Moxie.swf',
						filters: {
							mime_types: [
								{ title: "图片文件", extensions: "jpg,gif,png,bmp" }
							]
						},
						max_retries: 3,
						dragdrop: true,
						drop_element: 'editor-container',
						chunk_size: '4mb',
						auto_start: true, 
						init: 
							'FilesAdded': (up, files) ->
								plupload.each(files, (file) ->
								);
							,
							'BeforeUpload': (up, file) ->
								file.name = "#{Meteor.userId()}#{(new Date()).getTime()}#{file.name}"
							,
							'UploadProgress': (up, file) ->
								editor.showUploadProgress(file.percent);
							,
							'FileUploaded': (up, file, info) ->
								domain = up.getOption('domain');
								res = $.parseJSON(info);
								sourceLink = domain + res.key + "?imageMogr2/thumbnail/#{width}/quality/100";
								editor.command(null, 'insertHtml', '<img src="' + sourceLink + '" style="max-width:100%;"/>')

								console.log self.editor.get().$txt.html()
								localStorage.setItem("debateContent", self.editor.get().$txt.html())
							,
							'Error': (up, err, errTip) ->
								toastr.error TAPi18n.__(err.message)
							,
							'UploadComplete': ->
								editor.hideUploadProgress();
							'Key': (up, file) ->
								if file.name.lastIndexOf('.') >= 0
									extname = file.name.slice(file.name.lastIndexOf('.') - file.name.length)
								else
									extname = '';

								if extname == '' && file.type.indexOf('/') >= 0
									extname = '.' + file.type.split('/')[1];
								
								now = new Date()
								key = "debateIMG-" + Meteor.userId() + "-" + now.getTime() + extname
					);
				editorobj.create();
				#console.log "create end",TAGT.models.Debate.findOne(FlowRouter.current().params.slug)?.htmlBody
				editorobj.$txt.html(TAGT.utils.extendImgSrcs(TAGT.models.Debate.findOne(FlowRouter.current().params.slug)?.htmlBody || localStorage.getItem("debateContent") || "", "?imageMogr2/thumbnail/#{width}/quality/100"))

				self.editor.set(editorobj)
				self.hasEditor.set(true)
	, 100

	

Template.debateEdit.events
	
	'change .add-img input[type=file]': (event, instance) ->
		event = event.originalEvent or event
		files = event.target.files
		if not files or files.length is 0
			files = event.dataTransfer?.files or []

		filesToUpload = []
		for file in files
			filesToUpload.push
				file: file
				name: file.name

		fileUpload filesToUpload


	'click .icon-ok-a': (event, instance)->
		$(".icon-ok-a").addClass('load-circle');
		if !Session.get("debateType")? || Session.get("debateType")==undefined
			$("#debateType").openModal()
		else
			instance.createDebate()
		interval = Meteor.setInterval ->
			if Session.get("debateType")? && Session.get("debateType")!=undefined && $(".icon-ok-a").hasClass('load-circle')
				Meteor.clearInterval interval
				instance.debateType.set Session.get("debateType")
				instance.save.set(true)

				Session.set("debateType", null)
				
				instance.createDebate()
			
		, 100
		
	'keyup .debate-name': (event, instance) ->
		instance.name.set(event.currentTarget.value);

	'keyup .edit-content': (event, instance) ->
		localStorage.setItem("debateContent", instance.editor.get().$txt.html())

Template.debateEdit.onDestroyed ->
	console.log "onDestroyed"
