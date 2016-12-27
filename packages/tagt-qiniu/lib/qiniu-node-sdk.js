if (Meteor.isServer) {
    // Fiber = Npm.require("fibers");
    // CurrentName = new Meteor.EnvironmentVariable;
    qiniu = Npm.require('qiniu');


    var ak = '38r8ofsGSxGUBDroPuG-nARcI0Hgpxh_PWAgEtw6';
    var sk = 'nLw07k_X6D17JnflH0tNbFx7yfijskZ1m3hi1_2n';
    // qiniu.bucketname = 'mylice';
    qiniu.bucketnameAvatar = "avatar";
    qiniu.bucketnamePlanPicture = "planpicture";
    qiniu.bucketnameTravelStoryPicture = "travelstorypicture";
    

    qiniu.conf.SECRET_KEY = sk;
    qiniu.conf.ACCESS_KEY = ak;
    // var putPolicy = new qiniu.rs.PutPolicy(qiniu.bucketname);
    // var productsUptoken = new qiniu.rs.PutPolicy(qiniu.bucketname).token();
    var avatarUptoken = new qiniu.rs.PutPolicy(qiniu.bucketnameAvatar).token();
    var planPictureUptoken = new qiniu.rs.PutPolicy(qiniu.bucketnamePlanPicture).token();
    var travelStoryPictureUptoken = new qiniu.rs.PutPolicy(qiniu.bucketnameTravelStoryPicture).token();
    // 转换异步接口为同步

    qiniuClient = new qiniu.rs.Client();
    wrappedQiniuIo = Async.wrap(qiniu.io, ['put']);
    wrappedQiniuClient = Async.wrap(qiniuClient, ['stat', 'remove', 'copy', 'move']); //获取基本信息，移动...

    // 上传二进制头像文件
    qiniu.uploadBuf = function(avatarBuf) {
        var uptoken = putPolicy.token();
        var extra = new qiniu.io.PutExtra();
        extra.mimeType = 'image/jpeg';
        return wrappedQiniuIo.put(uptoken, '', avatarBuf, extra);
    };

    qiniu.uploadAvatar = function(file) {
        var suff = file.file.name.substr(file.file.name.lastIndexOf('.'), file.file.name.length);
        var key = new Date().getTime() + suff;
        var extra = new qiniu.io.PutExtra();
        extra.mimeType = file.file.type;
        qiniu.io.putFile(avatarUptoken, key, file.file.path, extra, function(err, ret) {
            if (err) {
                throw new Meteor.Error(601, err);
            }
            
        });
        return key;
    }

    qiniu.uploadPlanPicture = function(file) {
        var suff = file.file.name.substr(file.file.name.lastIndexOf('.'), file.file.name.length);
        var key = new Date().getTime() + suff;
        var extra = new qiniu.io.PutExtra();
        extra.mimeType = file.file.type;
        qiniu.io.putFile(planPictureUptoken, key, file.file.path, extra, function(err, ret) {
            if (err) {
                throw new Meteor.Error(601, err);
            }
            
        });
        return key;
    }
    qiniu.uploadTravelStoryPicture = function(file) {
        var suff = file.file.name.substr(file.file.name.lastIndexOf('.'), file.file.name.length);
        var key = new Date().getTime() + suff;
        var extra = new qiniu.io.PutExtra();
        extra.mimeType = file.file.type;
        qiniu.io.putFile(travelStoryPictureUptoken, key, file.file.path, extra, function(err, ret) {
            
            if (err) {
                throw new Meteor.Error(601, err);
            }
            
        });
        return key;
    }
}