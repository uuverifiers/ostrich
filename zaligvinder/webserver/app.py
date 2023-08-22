from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib
import webserver.routing

class CustomHandler(BaseHTTPRequestHandler):
  def __init__(self,router,*args, **kwargs):
    self._router = router

  #THis is an awful hack, but it works
  def __call__(self, *args):
        """ Handle a request """
        super().__init__(*args)
    
  # GET
  def do_GET(self):
    print (self.path)
    res = urllib.parse.urlparse(self.path)
    print (res[2])
    params = urllib.parse.parse_qs (res[4])
    print (params)
    view = self._router.doRouting (res[2],params)
    
    # Send response status code
    view.response_code(self)
    
    # Send headers
    view.header(self)
    
    # Send View Content
    view.message(self.wfile)

class App:
  def __init__(self,name = "MyServer",router = webserver.routing.Router ()):
    self._router = router
    self._address = ('127.0.0.1',8081)

  def addEndpoint (self,name,callable):
    self._router.addEndpoint (name,callable)


  def run (self):
    print ("Starting server...")
    handler = CustomHandler (self._router)
    httpd = HTTPServer(self._address, handler)
    print('running server...')
    httpd.serve_forever()
    
  
