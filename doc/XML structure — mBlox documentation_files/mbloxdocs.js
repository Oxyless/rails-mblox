var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-23435615-1']);
_gaq.push(['_setDomainName', 'mblox.com']);
_gaq.push(['_trackPageview']);

(function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

  
$(function() {
	$(".ballot_yes").parent().addClass("ballot_yes");
	$(".ballot_no").parent().addClass("ballot_no");
	
	$("a[href='#']").click(function(event) {
		event.preventDefault();
	});
	
	var url = document.URL.split("/");
	
	if (url.length > 5) {
		$('#homenav').removeClass("active");
		
		if (url[5] == 'sms') {
			$('#smsnav').addClass("active");
		} else if (url[5] == 'push') {
			$('#pushnav').addClass("active");
		} else if (url[5] == 'em') {
			$('#emnav').addClass("active");
		} 
	}
});




