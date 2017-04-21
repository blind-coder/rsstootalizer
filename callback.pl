#!/usr/bin/perl -w

print <<EOF
Content-Type: text/html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<script src="static/js/jquery.min.js"></script>
	<script src="static/js/Tweetodon.js"></script>
</head>
<body>
<script type="text/javascript">
function TweetodonOnReady(){
	var l = "index.pl?mode=Callback&code="+_GET.code;
	document.location.href=l;
}
</script>
</body>
</html>
EOF
