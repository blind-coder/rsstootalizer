function populateGet() {
	var obj = {}, params = location.search.slice(1).split('&');
	for(var i=0,len=params.length;i<len;i++) {
		var keyVal = params[i].split('=');
		obj[decodeURIComponent(keyVal[0])] = decodeURIComponent(keyVal[1]);
	}
	return obj;
}
var _GET;

function jNotify(title, message){
	$.notify({
		title: title,
		message: message
	},{
		template: '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
			'<button type="button" aria-hidden="true" class="close" data-notify="dismiss">×</button>' +
			'<span data-notify="icon"></span> ' +
			'<span data-notify="title">{1}</span><br /> ' +
			'<span data-notify="message">{2}</span>' +
			'<div class="progress" data-notify="progressbar">' +
			'<div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>' +
			'</div>' +
			'<a href="{3}" target="{4}" data-notify="url"></a>' +
			'</div>',
		offset: {
			x: 120,
			y: 20
		}
	}
	);
}
function jAlert(title, message){
	$.notify({
		title: title,
		message: message
	},{
		type: "danger",
		template: '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
			'<button type="button" aria-hidden="true" class="close" data-notify="dismiss">×</button>' +
			'<span data-notify="icon"></span> ' +
			'<span data-notify="title">{1}</span><br /> ' +
			'<span data-notify="message">{2}</span>' +
			'<div class="progress" data-notify="progressbar">' +
			'<div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>' +
			'</div>' +
			'<a href="{3}" target="{4}" data-notify="url"></a>' +
			'</div>',
		offset: {
			x: 120,
			y: 20
		}
	}
	);
}

$(document).ready(function($){
	$(".sidebar").find("#"+$("#currentmode").val()).addClass("active");
	_GET = populateGet();
	if (typeof TweetodonOnReady == "function"){
		TweetodonOnReady();
	}
});
