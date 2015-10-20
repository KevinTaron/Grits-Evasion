import cgi
import datetime
import urllib
import webapp2
import jinja2
import os 
import StringIO
import re

jinja_environment = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)))


from google.appengine.api import users
from google.appengine.api import memcache
from google.appengine.ext import db

from google.appengine.api.urlfetch import fetch
import xml.dom.minidom as dom


class MainPage(webapp2.RequestHandler):
    def get(self):
        template_values = {
        }

        template = jinja_environment.get_template('index.html')
        self.response.out.write(template.render(template_values))

class Weltmeister(webapp2.RequestHandler):
    def get(self):
        template_values = {
        }

        template = jinja_environment.get_template('weltmeister.html')
        self.response.out.write(template.render(template_values))





app = webapp2.WSGIApplication([('/', MainPage), ('/weltmeister.html', Weltmeister)],
                              debug=True)
