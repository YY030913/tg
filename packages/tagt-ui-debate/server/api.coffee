#multer = Npm.require('multer');
#formidable = Npm.require('formidable');
#multipart = Npm.require('connect-multiparty');
#multipart = Npm.require('./connectMultiparty.js');/Users/xiaoyu/meteor/tp/.meteor/local/build/programs/server/npm/node_modules/meteor/tagt_ui-debate/

qiniu = Npm.require('qiniu');
#需要填写你的 Access Key 和 Secret Key
qiniu.conf.ACCESS_KEY = '38r8ofsGSxGUBDroPuG-nARcI0Hgpxh_PWAgEtw6';
qiniu.conf.SECRET_KEY = 'nLw07k_X6D17JnflH0tNbFx7yfijskZ1m3hi1_2n';


#构建上传策略函数
uptoken = (bucket, key) ->
  putPolicy = new qiniu.rs.PutPolicy(bucket+":"+key);
  return putPolicy.token();

Api = new Restivus
	enableCors: true
	apiPath: 'api/'

Api.addRoute 'uptoken', authRequired: false,
	get: ->
		try
			uptoken = new qiniu.rs.PutPolicy("debateimgs");
			token = uptoken.token();
			if token 
				return TAGT.API.v1.success
					ts: Date.now()
					"Cache-Control": "max-age=0, private, must-revalidate"
					Pragma: "no-cache"
					Expires: 0
					uptoken: token

			
		catch e
			return TAGT.API.v1.failure e.error

Api.addRoute 'roomuptoken', authRequired: false,
	get: ->
		try
			uptoken = new qiniu.rs.PutPolicy("roomimgs");
			token = uptoken.token();
			if token 
				return TAGT.API.v1.success
					ts: Date.now()
					"Cache-Control": "max-age=0, private, must-revalidate"
					Pragma: "no-cache"
					Expires: 0
					uptoken: token

			
		catch e
			return TAGT.API.v1.failure e.error
###
WebApp.connectHandlers.use(multer({
            dest: './uploads/',
            rename: (fieldname, filename) ->
                return filename + Date.now();
            ,
            onFileUploadStart: (file) ->
                console.log(file.originalname + ' is starting ...');
            ,
            onFileUploadComplete: (file) ->
                console.log(file.fieldname + ' uploaded to  ' + file.path);
                fileName = file.name;
                done = true;
        }))
###
#multipartMiddleware = multipart();

#WebApp.connectHandlers.use(multipartMiddleware)

WebApp.connectHandlers.use("/uploadDebateImg", (req, res, next) ->
	try
		file = req.files['wangEditorMobileFile'];
		if file?
			tempfilepath = file.path;
			type = file.type;
			filename = file.name;
			if filename.lastIndexOf('.') >= 0
				extname = filename.slice(filename.lastIndexOf('.') - filename.length)
			else
				extname = '';

			if extname == '' && type.indexOf('/') >= 0
				extname = '.' + type.split('/')[1];
			
			filename = Math.random().toString().slice(2) + extname;

			console.log "filename",filename
			#要上传的空间
			bucket = 'debateimgs';

			suff = file.name.substr(file.name.lastIndexOf('.'), file.name.length);
			#上传到七牛后保存的文件名
			key = new Date().getTime() + extname;
			extra = new qiniu.io.PutExtra();
			extra.mimeType = file.type;

			#生成上传 Token
			token = uptoken(bucket, key);


			qiniu.io.putFile(token, key, tempfilepath, extra, (err, ret) ->
				if err
					console.log "error",err
					throw new Meteor.Error(601, err);
				else
					res.writeHead(200);
					res.end("http://o8rnbrutf.bkt.clouddn.com/#{ret.key}");
			);
		else
			res.writeHead(200);
			res.end("error: no catch file!");
	catch e
		res.writeHead(200);
		res.end("error: no catch file req!");
		return
);
