import png

import json
import os
import StringIO
import sys
import traceback

from google.appengine.api import users
from google.appengine.ext import ndb
from google.appengine.api import images

import jinja2
import webapp2

JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)

Link = {
    "Room_N_red": {
        "1": "Room_N_blue",
        },
    "Room_N_blue": {
        "1": "Room_N_red",
        },
    }

def user_key(user):
    return ndb.Key(Player, user.user_id())

class Player(ndb.Model):
    """Models where a player is."""
    player = ndb.UserProperty()
    place = ndb.StringProperty(indexed=False)

    @classmethod
    def get_entity(cls, user):
        query = user_key(user).get()
        if not query:
            query = Player(key=user_key(user), player=user, place="Room_N_red")
            query.put()

        return query

class MainPage(webapp2.RequestHandler):
    def get(self):
        user = users.get_current_user ()

        if not user:
            self.redirect (users.create_login_url (self.request.uri))
            return

        template_values = {
            "name": user.nickname(),
        }

        template = JINJA_ENVIRONMENT.get_template("index.html")
        self.response.write(template.render(template_values))

class PlacePage(webapp2.RequestHandler):
    def get(self):
        user = users.get_current_user ()

        if not user:
            self.redirect (users.create_login_url (self.request.uri))
            return

        player = Player.get_entity(user)

        template_values = {
            "place": player.place,
        }
        template = JINJA_ENVIRONMENT.get_template("place.html")
        self.response.write(template.render(template_values))

def get_path (place, i):
    return "masks/%s/active%d.png" % (place, i)

class LookPage(webapp2.RequestHandler):
    def get(self):
        user = users.get_current_user ()

        if not user:
            self.redirect (users.create_login_url ("/"))
            return

        place = self.request.get("place")
        x = int(self.request.get("x"))
        y = int(self.request.get("y"))

        i = 1
        while os.path.exists(get_path(place, i)):
            image = png.Reader(open(get_path(place, i))).read()
            rows = list(image[2])
            if rows[y][x * 3]:
                player = Player.get_entity(user)
                try:
                    player.place = Link[place][str(i)]
                    self.response.write(player)
                except KeyError:
                    pass
                player.put()
                return
            i += 1

class ConsolePage(webapp2.RequestHandler):
    def get(self):

        template = JINJA_ENVIRONMENT.get_template("console.html")
        self.response.write(template.render())

class EvalAjax(webapp2.RequestHandler):
    def get(self):
        try:
            if self.request.get("evaluator") == "eval":
                self.response.write("R" + str(eval(self.request.get("input"))))
            elif self.request.get("evaluator") == "exec":
                real_stdout = sys.stdout

                sys.stdout = StringIO.StringIO() # So I'm a Lisp hacker
                exec(self.request.get("input"))
                self.response.write("P" + sys.stdout.getvalue())
                sys.stdout.close()

                sys.stdout = real_stdout
        except:
            self.response.write("E" + traceback.format_exc())

app = webapp2.WSGIApplication ([('/', MainPage),
                                ('/place', PlacePage),
                                ('/look', LookPage),
                                ('/console', ConsolePage),
                                ('/code', EvalAjax)],
                               debug=True)
