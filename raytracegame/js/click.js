function pick_color(e) {
    var left = $(this).offset().left;
    var top = $(this).offset().top;

    $("#x").val(e.pageX - left);
    $("#y").val(e.pageY - top);
    $("#act").submit();
}

function init() {
    $("#rendered").click(pick_color);
}

$(document).ready(init);
