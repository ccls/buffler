jQuery(function(){

/*
	var root = (location.host == 'ccls.berkeley.edu')?'/buffler':''
	jQuery.getScript(root + 
*/
	jQuery.getScript(
		'/javascripts/cache_helper.js?caller=' +
		location.pathname );
/*
		location.pathname.replace(new RegExp('^' + root),'') );
*/

});
