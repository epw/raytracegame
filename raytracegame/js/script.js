var WIDTH = 900;
var HEIGHT = 900;

var canvas;
var placename;
var photosphere;
var renderer;
var scene;
var camera;
var pointer;

var theta = Math.PI;
var phi = 0;
var look_at_point;

var img;

function getImage() {
    return $("#photosphere").attr("src");
}

function init() {
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(45, WIDTH / HEIGHT, .1, 20);
    
    var geometry = new THREE.SphereGeometry(2, 32, 32);
    material = new THREE.MeshPhongMaterial({map: THREE.ImageUtils.loadTexture(getImage())});
    photosphere = new THREE.Mesh(geometry, material);
    photosphere.scale.x = -1;
    scene.add(photosphere);

    scene.add(new THREE.AmbientLight(0xffffff));
    var light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(0, 0, 0);
    scene.add(light);

    renderer = new THREE.WebGLRenderer();
    renderer.setSize(WIDTH, HEIGHT);
    renderer.domElement.className = "viewport";
    document.body.appendChild(renderer.domElement);

    look_at_point = new THREE.Vector3(0, 0, 1);
    camera.up = new THREE.Vector3(0, 1, 0);
    camera.lookAt(look_at_point);

    $("#pointer").css({left: WIDTH / 2, top: HEIGHT / 2});
    if ("ontouchstart" in window) {
	$("#pointer").css({display: "inline"});
    }
    
    canvas = $("canvas.viewport")[0];
    canvas.addEventListener("click", mouseclick);
    document.addEventListener("pointerlockchange", pointerlockchange, false);
    document.addEventListener("touchstart", touchstart, false);
    document.addEventListener("touchmove", touchmove, false);
    document.addEventListener("touchend", touchend, false);

    img = $("#photosphere")[0];
    placename = $("#placename").val();
}

function click_result(json) {
    data = JSON.parse(json);
    if (data.new_room) {
	placename = data.new_room;
	photosphere.material = new THREE.MeshPhongMaterial({map: THREE.ImageUtils.loadTexture("places/" + data.new_room + "/rendered.png")});
    }
}

function click_event() {
    var x = (theta / (Math.PI * 2)) * img.width;
    var y = img.height - ((phi + Math.PI / 2) / Math.PI) * img.height;
    $.post("/click_event", {"x": Math.floor(x), "y": Math.floor(y),
			    "place": placename},
	   click_result);
}

function mouseclick(e) {
    switch (e.button) {
    case 0:
	if (document.pointerLockElement == canvas) {
	    click_event();
	}
	break;
    case 1:
	e.preventDefault();
	canvas.requestPointerLock();
	break;
    }
}

function pointerlockchange(e) {
    if (document.pointerLockElement == canvas) {
	$("#pointer").css({display: "inline"});
	document.addEventListener("mouseup", mouseup, false);
	document.addEventListener("mousemove", mousemove, false);
    } else {
	$("#pointer").css({display: "none"});
    }
}

function mouseup(e) {
    if (e.button == 1 || e.button == 2) {
	document.exitPointerLock();
    }
}

function mouse_adjust_view(x, y) {
    theta += x / 300.0;
    phi -= y / 300.0;
}

function mousemove(e) {
    if (document.pointerLockElement == canvas) {
	if (Math.abs(e.movementX) > 50 || Math.abs(e.movementY) > 50) {
	    // Probably had an unlock event that is still being processed.
	    setTimeout(function () {
		if (document.pointerLockElement == canvas) {
		    mouse_adjust_view(e.movementX, e.movementY);
		}
	    },
		       10);
	} else {
	    mouse_adjust_view(e.movementX, e.movementY);
	}
    }
}

var last_touch_x = -1;
var last_touch_y = -1;
var just_tap = false;

function touchstart(e) {
    e.preventDefault();
    last_touch_x = e.changedTouches[0].pageX;
    last_touch_y = e.changedTouches[0].pageY;
    just_tap = true;
}

function touchmove(e) {
    e.preventDefault();
    just_tap = false;
    if (last_touch_x != -1) {
	theta -= (e.changedTouches[0].pageX - last_touch_x) / (WIDTH + 0.0);
	phi += (e.changedTouches[0].pageY - last_touch_y) / (HEIGHT + 0.0);
    }
    last_touch_x = e.changedTouches[0].pageX;
    last_touch_y = e.changedTouches[0].pageY;
}    

function touchend(e) {
    e.preventDefault();
    if (just_tap) {
	click_event();
    }
}

function animate() {
    requestAnimationFrame(animate);

    if (phi <= -Math.PI / 2) {
	phi = -Math.PI / 2;
    }
    if (phi >= Math.PI / 2) {
	phi = Math.PI / 2;
    }

    while (theta < 0) {
	theta += Math.PI * 2;
    }
    while (theta > Math.PI * 2) {
	theta -= Math.PI * 2;
    }

    look_at_point.x = Math.cos(theta) * Math.cos(phi);
    look_at_point.y = Math.sin(phi);
    look_at_point.z = Math.sin(theta) * Math.cos(phi);
    camera.lookAt(look_at_point);
//    pointer.position.x = look_at_point.x;
//    pointer.position.y = look_at_point.y;
//    pointer.position.z = look_at_point.z;
//    pointer.rotation.y = -(theta + Math.PI / 2);

    renderer.render(scene, camera);
}

init();
animate();
