import webserver.views.TextView
import re

class ExactMatch:
    def __init__(self,path):
        self._path = path

    def match (self,query):
        if query == self._path:
            return True, {}
        else:
            return False, None

class RegexMatch:
    def __init__(self,path):
        self._path = path+"$"

    def match (self,query):
        m = re.match(self._path, query)
        if m:
            return True,m.groupdict ()
        else:
            return False,None
        
class Router:
    def __init__(self):
        self._endpoints = []
        
    def doRouting (self,path,params):
        path = path.strip ("/")
        for name,callable in self._endpoints:
            parser,p = name.match (path)
            if parser:
                #print ("JJJ",params)
                params.update(p)
                return callable (params)
            
        return webserver.views.TextView.ErrorText ("Unknown Endpoint")
    
    def addEndpoint (self,name,callable):
        self._endpoints.append ((name,callable)) 
        
