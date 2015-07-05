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
<html>
  <head>
    <script src="js/jquery.min.js"></script>
  </head>
  <body>
    <form id="act" method="POST" action="/">
      <img id="rendered" src="places/{{.}}/rendered.png">
      <input id="place" name="place" type="hidden" value="{{.}}">
      <input id="x" name="x" type="hidden" value="">
      <input id="y" name="y" type="hidden" value="">
    </form>
    <script src="js/click.js"></script>
  </body>
</html>
`

var displayTemplate = template.Must(template.New("sign").Parse(displayHTML))

func maskAt(x int, y int) string {
	maskFiles, err := ioutil.ReadDir("masks/Room_N_red")
	if err != nil {
		return "0"
	}
	for _, maskFile := range maskFiles {
		f, err := os.Open("masks/Room_N_red/" + maskFile.Name())
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
	return "0"
}

func newRoom(place string, x int, y int) string {
	if x == -1 {
		return place
	}
	mask := maskAt(x, y)
	log.Printf("Mask: %v", mask)

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

func root(w http.ResponseWriter, r *http.Request) {
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
		place = "Room_N_red"
	}
	room := newRoom(place, x, y)
	if room == "" {
		room = place
	}
	err = displayTemplate.Execute(w, room)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
