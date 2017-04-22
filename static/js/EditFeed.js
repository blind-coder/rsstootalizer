var newnum = 0;
function appendFilter(id, field, regex, type, match){
	console.log("id: "+id+" field: "+field+" regex: "+regex+" type: "+type);
	var t = $("div#filters table tbody");
	var a = "<tr>";
	a += "<td>";
	a += "<select name='field_"+id+"' id='field_"+id+"'>";
	a += "<option disabled selected value='0'>Please select</option>";
	a += "<option disabled value='0'>-------------</option>";
	a += "<option value='id'>ID</option>";
	a += "<option value='title'>Title</option>";
	a += "<option value='link'>Link</option>";
	a += "<option value='content'>Content</option>";
	a += "<option value='author'>Author</option>";
	a += "<option value='issued'>Issued</option>";
	a += "<option value='modified'>Modified</option>";
	a += "<option value='tags'>Tags</option>";
	a += "</select>";
	a += "</td>";
	a += "<td>";
	a += "<select name='match_"+id+"' id='match_"+id+"'>";
	a += "<option value='positive'>Matches</option>";
	a += "<option value='negative'>Does not match</option>";
	a += "</select>";
	a += "</td>";
	a += "<td><input type='text' placeholder='Match.*?some.*regex' name='regex_"+id+"' id='regex_"+id+"'></td>";
	a += "<td>";
	a += "<select name='type_"+id+"' id='type_"+id+"'>";
	a += "<option disabled selected value='0'>Please select</option>";
	a += "<option disabled value='0'>-------------</option>";
	a += "<option value='white'>Whitelist</option>";
	a += "<option value='black'>Blacklist</option>";
	a += "</select>";
	a += "</td>";
	if (!(""+id).match(/^new/)){
		a += "<td><input type='checkbox' name='delete_"+id+"'></td>";
	}
	a += "</tr>";
	t.append(a);
	if (field){
		t.find("#field_"+id).val(field);
	}
	if (regex){
		t.find("#regex_"+id).val(regex);
	}
	if (type){
		t.find("#type_"+id).val(type);
	}
	if (match){
		t.find("#match_"+id).val(match);
	}
}
function TweetodonOnReady(){
	$("#rawentries").hide();
	$("a#togglerawentries").on("click", function(){
		$("#rawentries").toggle();
	});

	$("a#addfilter").on("click", function(){
		newnum++;
		appendFilter("new"+newnum);
	});
	$("a#savefilters").one("click", function(){
		document.forms.form_filters.submit();
	});

	for (i=0; i<filters.length; i++){
		appendFilter(filters[i].ID, filters[i].field, filters[i].regex, filters[i].type, filters[i].match);
	}
}
