// Place ymur application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function do_js_click_highlight_note(album_id) {
	var note = $('notes_'+album_id);
	note.focus();
	note.select();
}

function do_js_focus_highlight_note(album_id) {
	var browser_vendor=navigator.vendor;
	if (browser_vendor != "Apple Computer, Inc.")
	{
		var note = $('notes_'+album_id);
		note.focus();
		note.select();
	}
}

function do_js_set_note(album_id) {
	var note = $('notes_'+album_id);
	new Ajax.Request('/ltrs/set_note?album_id='+album_id+'&note='+escape(note.getValue())+'&session_id='+session_id, {asynchronous:true, evalScripts:true});
}

function do_js_start_load() {
	$('loaded_frame').hide();
	$('progress_dialog').show();
	return false;
}

function do_js_finish_load() {
	$('progress_dialog').hide();
	$('loaded_frame').show();
}

function do_js_set_upper_year(year) {
	return false;
}

function do_js_get_paged_albums(page, album_div) {
	do_js_start_load();
	new Ajax.Updater(album_div, '/ltrs/get_'+album_div+'?page='+page+'&session_id='+session_id, {asynchronous:true, evalScripts:true, onComplete:function(request){do_js_finish_load()}});
	return false;
}

function do_js_get_others_albums(fb_other_in, album_div) {
	do_js_start_load();
	new Ajax.Updater(album_div, '/ltrs/get_'+album_div+'?page=1&fb_other_in='+fb_other_in+'&session_id='+session_id, {asynchronous:true, evalScripts:true, onComplete:function(request){do_js_finish_load()}});
	return false;
}

function do_js_get_sorted_albums(sort_by, album_div) {
	do_js_start_load();
	new Ajax.Updater(album_div, '/ltrs/get_'+album_div+'?page=1&sort_by='+sort_by+'&session_id='+session_id, {asynchronous:true, evalScripts:true, onComplete:function(request){do_js_finish_load()}});
	return false;
}

function do_js_get_wanted_albums(wanted_type, album_div) {
	do_js_start_load();
	new Ajax.Updater(album_div, '/ltrs/get_'+album_div+'?page=1&wanted_type='+wanted_type+'&session_id='+session_id, {asynchronous:true, evalScripts:true, onComplete:function(request){do_js_finish_load()}});
	return false;
}

function do_js_populate_filters(filter_by) {
	new Ajax.Updater('filter_details', '/ltrs/populate_filters?filter_by='+filter_by+'&session_id='+session_id, {asynchronous:true, evalScripts:true, onComplete:function(request){Element.show('filter_go')}});
	return false;
}

function do_js_get_filtered_albums(album_div) {
	do_js_start_load();
	var filter_details_1 = $('filter_details_1_select');
	if (document.getElementById('filter_details_2_select'))
	{
		var filter_details_2 = $('filter_details_2_select');
		new Ajax.Updater(album_div, '/ltrs/get_'+album_div+'?page=1&filter_details_1='+filter_details_1.getValue()+'&filter_details_2='+filter_details_2.getValue()+'&session_id='+session_id, {asynchronous:true, evalScripts:true, onComplete:function(request){do_js_finish_load()}});
	}
	else
	{
		new Ajax.Updater(album_div, '/ltrs/get_'+album_div+'?page=1&filter_details_1='+filter_details_1.getValue()+'&session_id='+session_id, {asynchronous:true, evalScripts:true, onComplete:function(request){do_js_finish_load()}});
	}
	return false;
}

function do_js_set_format(album_id, id) {
	var div_element = $('format_'+album_id);
	div_element.update("<li class='current-format-"+id+"'></li>");
	new Ajax.Updater('format_'+album_id, '/ltrs/set_format?album_id='+album_id+'&format_id='+id+'&session_id='+session_id, {asynchronous:true, evalScripts:true});
	return false;
}

function do_js_set_heard(album_id, id) {
	var div_element = $('heard_'+album_id);
	div_element.update("<li class='current-heard-"+id+"'></li>");
	new Ajax.Updater('heard_'+album_id, '/ltrs/set_heard?album_id='+album_id+'&heard_id='+id+'&session_id='+session_id, {asynchronous:true, evalScripts:true});
	return false;
}

function do_js_set_owned(album_id, id) {
	var div_element = $('owned_'+album_id);
	div_element.update("<li class='current-owned-"+id+"'></li>");
	new Ajax.Updater('owned_'+album_id, '/ltrs/set_owned?album_id='+album_id+'&owned_id='+id+'&session_id='+session_id, {asynchronous:true, evalScripts:true});
	return false;
}

function do_js_set_rating(album_id, id) {
	var div_element = $('rating_'+album_id);
	div_element.update("<li class='current-rating-"+id+"'></li>");
//
// Hack in showing that you've heard it if you rate it!
//
	var div_element = $('heard_'+album_id);
	div_element.update("<li class='current-heard-1'></li>");
	new Ajax.Updater('rating_'+album_id, '/ltrs/set_rating?album_id='+album_id+'&rating='+id+'&session_id='+session_id, {asynchronous:true, evalScripts:true});
	return false;
}

function do_js_clear_details(album_id) {
	new Ajax.Updater('user_details_'+album_id, '/ltrs/clear_details?album_id='+album_id+'&session_id='+session_id, {asynchronous:true, evalScripts:true});
	return false;
}

function do_js_set_state(sid) {
	session_id = sid;
	return false;
}

function do_js_break_into_debugger() {
	debugger;
}

function getNewSubmitForm(){
  var submitForm = document.createElement("FORM");
  document.body.appendChild(submitForm);
  submitForm.method = "POST";
	submitForm.target = "Printable Albums";
	submitForm.setAttribute('onsubmit',"window.open('','Printable Albums')");	
  return submitForm;
}

//helper function to add elements to the form
function createNewFormElement(inputForm,sid){
	var newElement = document.createElement("input");
	newElement.setAttribute('type','hidden');
	newElement.setAttribute('name','session_id');
	newElement.setAttribute('value',sid);
  inputForm.appendChild(newElement);
  return newElement;
}

//function that creates the form, adds some elements
//and then submits it
function do_js_create_printable_list(sid) {
  var submitForm = getNewSubmitForm();
  createNewFormElement(submitForm,sid);
  submitForm.action= "http://1001Albums.fisheyedev.com/ltrs/printable_list";
	submitForm.submit();
}

//function that creates the form, adds some elements
//and then submits it
function do_js_create_mobile_list(sid) {
  var submitForm = getNewSubmitForm();
  createNewFormElement(submitForm,sid);
  submitForm.action= "http://1001Albums.fisheyedev.com/ltrs/mobile_list";
	submitForm.submit();
}

Ajax.Base.prototype.initialize = Ajax.Base.prototype.initialize.wrap(
    function (callOriginal, options) {
        var headers = options.requestHeaders || {};
        headers["X-CSRF-Token"] = AUTH_TOKEN
        options.requestHeaders = headers;
        return callOriginal(options);
    }
);
