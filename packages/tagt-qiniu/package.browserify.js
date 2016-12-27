qiniu = require('qiniu');
// 引入七牛 node.js SDK
// qiniu = require('qiniu');

// 创建上传策略：服务端上传
/* ==================++++填写下面三个参数++++=================*/
var ak = '38r8ofsGSxGUBDroPuG-nARcI0Hgpxh_PWAgEtw6';
var sk = 'nLw07k_X6D17JnflH0tNbFx7yfijskZ1m3hi1_2n';
qiniu.bucketname = 'mylice';


qiniu.conf.SECRET_KEY = sk;
qiniu.conf.ACCESS_KEY = ak;
var putPolicy = new qiniu.rs.PutPolicy(qiniu.bucketname);

// 转换异步接口为同步

var qiniuClient = new qiniu.rs.Client();
qiniu.wrappedQiniuIo = Async.wrap(qiniu.io, ['put']);
qiniu.wrappedQiniuClient = Async.wrap(qiniuClient, ['stat', 'remove', 'copy', 'move']); //获取基本信息，移动...

// 上传二进制头像文件
qiniu.uploadBuf = function(avatarBuf) {
  var uptoken = putPolicy.token();
  var extra = new qiniu.io.PutExtra();
  extra.mimeType = 'image/jpeg';
  return wrappedQiniuIo.put(uptoken, '', avatarBuf, extra);
}

//构造上传函数
qiniu.uploadFile = function(uptoken, localFileOrFiles) {
	var key = _.now();
  	var extra = new qiniu.io.PutExtra();
  	var uploadSuccessFiles = "";
  	for (var i = 0; i < localFileOrFiles.length; i++) {
  		var localFile = localFileOrFiles[i];
  		console.log(localFile);
  		key = key + localFile.Name.subStr(localFile.Name.lastIndexOf("."));
  		qiniu.io.putFile(uptoken, key, localFile, extra, function(err, ret) {
	      	if(!err) {
	        	// 上传成功， 处理返回值
	        	uploadSuccessFiles += key + ",";
	        	console.log(ret.hash, ret.key, ret.persistentId);       
	      	} else {
	        	// 上传失败， 处理返回代码
	        	console.log(err);
	      	}
	 	});
  	}
    return uploadSuccessFiles.length > 0 ? uploadSuccessFiles.subStr(0, uploadSuccessFiles.length - 1) : void 0;
}
module.exports.qiniu;	