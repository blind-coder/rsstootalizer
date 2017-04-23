function RSSTootalizerOnReady(){
	$("form#addFeed").hide();
	$("a.deleteFeed").on("click", function(){
		var btn = $(this);
		if (confirm("Really delete this feed?")){
			var l = "index.pl?mode=Dashboard&delete="+btn.data("id");
			document.location.href=l;
		}
	});

	$("a.addFeed").on("click", function(){
		var btn=$(this);
		$("form#addFeed").show();
		btn.hide();
	});

	$("a.enable").on("click", function(){
		var btn = $(this);
		var l = "index.pl?mode=Dashboard&enable="+btn.data("id");
		document.location.href=l;
	});
	$("a.disable").on("click", function(){
		var btn = $(this);
		var l = "index.pl?mode=Dashboard&disable="+btn.data("id");
		document.location.href=l;
	});
}
