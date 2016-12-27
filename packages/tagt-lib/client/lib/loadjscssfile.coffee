loadjscssfile = (filename, filetype)->
	if filetype=="js"
		fileref=document.createElement('script')
		fileref.setAttribute("type","text/javascript")
		fileref.setAttribute("src", filename)
	else if filetype=="css"
		fileref=document.createElement("link")
		fileref.setAttribute("rel", "stylesheet")
		fileref.setAttribute("type", "text/css")
		fileref.setAttribute("href", filename)
	if (typeof fileref)?
		document.getElementsByTagName("body")[0].appendChild(fileref)