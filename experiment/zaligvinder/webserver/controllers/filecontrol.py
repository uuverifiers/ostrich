import webserver.views.TextView
import webserver.views.PNGView
import webserver.files

class FileControl:
    def __init__(self):
        self._locator = webserver.files.FileLocator ()

    def findFile (self,params):
        path = params["path"]
        if path.endswith (".png"):
            f =  self._locator.findFileBinary (params["path"])
            if f:
                return webserver.views.PNGView.PNGView (f)
        else:
            f =  self._locator.findFile (params["path"])
            if f:
                return webserver.views.TextView.TextView (f.read())
        return webserver.views.TextView.ErrorText ("File Not available")
