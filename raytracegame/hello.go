package hello

import (
	"bufio"
	"fmt"
	"html/template"
	"image/png"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"os"

	"appengine"
	"appengine/user"
)

func init() {
	http.HandleFunc("/click_event", click_event)
	http.HandleFunc("/", root)
}

func userLogin(w http.ResponseWriter, r *http.Request) *user.User {
	c := appengine.NewContext(r)
	u := user.Current(c)
	if u == nil {
		url, err := user.LoginURL(c, r.URL.String())
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return nil
		}
		w.Header().Set("Location", url)
		w.WriteHeader(http.StatusFound)
		return nil
	}
	return u
}

const displayHTML = `
<!DOCTYPE html>
<html>
<head>
<script src="js/jquery.min.js"></script>
<script src="js/three.min.js"></script>
<style>
  #placename { display: none }
  #photosphere { display: none }
  canvas.viewport { cursor: url(static/pointer.png), auto }
  canvas.map { float: right; width: 30%; display: none }
  #pointer { pointer-events: none; position: absolute; display: none }
</style>
</head>
<body>
  <span id="placename">{{.}}</span>
  <img id="photosphere" src="places/{{.}}/rendered.png">
  <img id="pointer" src="static/pointer.png">
  <script src="js/script.js"></script>
</body>
</html>
`

var displayTemplate = template.Must(template.New("sign").Parse(displayHTML))

func maskAt(place string, x int, y int) string {
	dir := "masks/" + place
	log.Printf("%v", dir)
	maskFiles, err := ioutil.ReadDir(dir)
	if err != nil {
		return ""
	}
	for _, maskFile := range maskFiles {
		f, err := os.Open(dir + "/" + maskFile.Name())
		if err != nil {
			continue
		}
		im, err := png.Decode(bufio.NewReader(f))
		if err != nil {
			continue
		}
		color := im.At(x, y)
		r, _, _, _ := color.RGBA()
		if r != 0 {
			return maskFile.Name()[len("active_"):len(maskFile.Name()) - len(".png")]
		}
	}
	return ""
}

func newRoom(place string, x int, y int) string {
	if x == -1 {
		return place
	}
	mask := maskAt(place, x, y)
	log.Printf("Mask: %v", mask)
	if mask == "" {
		return ""
	}
	
	file, err := os.Open("map.dat")
	if err != nil {
		return place
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	activePrefix := fmt.Sprintf(" %v ", mask)
	found := false
	for scanner.Scan() {
		line := scanner.Text()
		if found == false {
			if string(line) == place {
				found = true
				continue
			}
		} else {
			if len(line) == 0 || line[0] != ' ' {
				found = false
				continue
			}
			if len(line) >= len(activePrefix) && string(line[:len(activePrefix)]) == activePrefix {
				return string(line[len(activePrefix):])
			}
		}
	}
	return place
}


func click_event(w http.ResponseWriter, r *http.Request) {
	u := userLogin(w, r)
	if u == nil {
		return
	}

	x, err := strconv.Atoi(r.FormValue("x"))
	if err != nil {
		x = -1
	}
	y, err := strconv.Atoi(r.FormValue("y"))
	if err != nil {
		y = -1
	}
	place := r.FormValue("place")
	if place == "" {
		place = "First_Room"
	}

	log.Printf("Coords: (%v, %v)", x, y)
	
	new_room := newRoom(place, x, y)
	if new_room != "" {
		fmt.Fprintf(w, "{\"new_room\": \"%s\"}", new_room);
	} else {
		fmt.Fprintf(w, "{\"new_room\": false}")
	}
}


func root(w http.ResponseWriter, r *http.Request) {
	u := userLogin(w, r)
	if u == nil {
		return
	}
	
	err := displayTemplate.Execute(w, "First_Room")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
