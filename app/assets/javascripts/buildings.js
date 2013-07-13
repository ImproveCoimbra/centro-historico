function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
}


$(document).ready(function () {
    var photosDiv = $('div#photos-div');
    if (photosDiv.length > 0) {
        if (!isFileInputSupported) {
            photosDiv.hide();
            $('div#no-photos-div').show();
        }
    }

});
