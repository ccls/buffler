jQuery(function(){

/*
	var root = (location.host == 'ccls.berkeley.edu')?'/buffler':''
	jQuery.getScript(root + 

	jQuery.getScript(
		'/javascripts/cache_helper.js?caller=' +
		location.pathname );

		location.pathname.replace(new RegExp('^' + root),'') );
*/

	jQuery.getScript('/pages/translate.js');
	jQuery.getScript('/users/menu.js');
	if( location.pathname == '/' ){
		jQuery.getScript('/home_page_pics/random.js');
	}

});
