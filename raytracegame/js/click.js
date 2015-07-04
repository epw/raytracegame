function pick_color(e) {
  var left = $(this).offset().left;
  var top = $(this).offset().top;

  console.log("?place=" + $("#place").val() + "&x=" + (e.pageX - left) + "&y=" + (e.pageY - top));
  document.location.search = "?place=" + $("#place").val() + "&x=" + (e.pageX - left) + "&y=" + (e.pageY - top);
}

function init() {
    $("#rendered").click(pick_color);
}

$(document).ready(init);
