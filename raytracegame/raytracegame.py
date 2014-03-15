import png

import os
import StringIO
import sys
import traceback

from google.appengine.api import users
from google.appengine.api import images

import jinja2
import webapp2

JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)

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
                                ('/code', EvalAjax)],
                               debug=True)
