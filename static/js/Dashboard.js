function TweetodonOnReady(){
	$("a.deleteFeed").on("click", function(){
		var btn = $(this);
		if (confirm("Really delete this feed?")){
			var l = "index.pl?mode=Dashboard&delete="+btn.data("id");
			document.location.href=l;
		}
	});
}
