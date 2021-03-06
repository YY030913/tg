/* globals isSetNotNull, TAGTFileEmojiCustomInstance */
Meteor.startup(function() {
	let storeType = 'GridFS';

	if (TAGT.settings.get('EmojiUpload_Storage_Type')) {
		storeType = TAGT.settings.get('EmojiUpload_Storage_Type');
	}

	let TAGTStore = TAGTFile[storeType];

	if (!isSetNotNull(() => TAGTStore)) {
		throw new Error(`Invalid TAGTStore type [${storeType}]`);
	}

	console.log(`Using ${storeType} for custom emoji storage`.green);

	let path = '~/uploads';
	if (isSetNotNull(() => TAGT.settings.get('EmojiUpload_FileSystemPath'))) {
		if (TAGT.settings.get('EmojiUpload_FileSystemPath').trim() !== '') {
			path = TAGT.settings.get('EmojiUpload_FileSystemPath');
		}
	}

	this.TAGTFileEmojiCustomInstance = new TAGTStore({
		name: 'custom_emoji',
		absolutePath: path
	});

	return WebApp.connectHandlers.use('/emoji-custom/', Meteor.bindEnvironment(function(req, res/*, next*/) {
		let params =
			{emoji: decodeURIComponent(req.url.replace(/^\//, '').replace(/\?.*$/, ''))};

		if (_.isEmpty(params.emoji)) {
			res.writeHead(403);
			res.write('Forbidden');
			res.end();
			return;
		}

		let file = TAGTFileEmojiCustomInstance.getFileWithReadStream(encodeURIComponent(params.emoji));

		res.setHeader('Content-Disposition', 'inline');

		if (!isSetNotNull(() => file)) {
			//use code from username initials renderer until file upload is complete
			res.setHeader('Content-Type', 'image/svg+xml');
			res.setHeader('Cache-Control', 'public, max-age=0');
			res.setHeader('Expires', '-1');
			res.setHeader('Last-Modified', 'Thu, 01 Jan 2015 00:00:00 GMT');

			let reqModifiedHeader = req.headers['if-modified-since'];
			if (reqModifiedHeader != null) {
				if (reqModifiedHeader === 'Thu, 01 Jan 2015 00:00:00 GMT') {
					res.writeHead(304);
					res.end();
					return;
				}
			}

			let color = '#000';
			let initials = '?';

			let svg = `<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" pointer-events="none" width="50" height="50" style="width: 50px; height: 50px; background-color: ${color};">
	<text text-anchor="middle" y="50%" x="50%" dy="0.36em" pointer-events="auto" fill="#ffffff" font-family="Helvetica, Arial, Lucida Grande, sans-serif" style="font-weight: 400; font-size: 28px;">
		${initials}
	</text>
</svg>`;

			res.write(svg);
			res.end();
			return;
		}

		let fileUploadDate = undefined;
		if (isSetNotNull(() => file.uploadDate)) {
			fileUploadDate = file.uploadDate.toUTCString();
		}

		let reqModifiedHeader = req.headers['if-modified-since'];
		if (isSetNotNull(() => reqModifiedHeader)) {
			if (reqModifiedHeader === fileUploadDate) {
				res.setHeader('Last-Modified', reqModifiedHeader);
				res.writeHead(304);
				res.end();
				return;
			}
		}

		res.setHeader('Cache-Control', 'public, max-age=0');
		res.setHeader('Expires', '-1');
		if (isSetNotNull(() => fileUploadDate)) {
			res.setHeader('Last-Modified', fileUploadDate);
		} else {
			res.setHeader('Last-Modified', new Date().toUTCString());
		}
		if (/^svg$/i.test(params.emoji.split('.').pop())) {
			res.setHeader('Content-Type', 'image/svg+xml');
		} else {
			res.setHeader('Content-Type', 'image/jpeg');
		}
		res.setHeader('Content-Length', file.length);

		file.readStream.pipe(res);
	}));
});
