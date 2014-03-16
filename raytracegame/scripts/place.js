var place;

function got_mask(data) {
    if (data) {
	window.location.reload(true);
    }
}

function pick(e) {
    var offset = $("#rendered").offset();
    var x = e.pageX - offset.left;
    var y = e.pageY - offset.top;

    $.get("/look", {"place": place,
		    "x": x, "y": y}, got_mask);
}

function init() {
    $("#rendered").click(pick);
}

function set_place(directory) {
    place = directory;
}

$(document).ready(init);
