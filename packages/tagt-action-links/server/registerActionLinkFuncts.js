//Action Links namespace creation.

TAGT.actionLinks = {
	register : function(name, funct) {
		TAGT.actionLinks[name] = funct;
	}
};
