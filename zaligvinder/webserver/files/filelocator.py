import os

class FileLocator:
    def __init__ (self):
        self._path = os.path.dirname(os.path.abspath(__file__))
        
    def findFile (self,path):
        path = os.path.normcase (path)
        pp = os.path.join (self._path,path)
        if os.path.isfile(pp):
            return open(pp)
        else:
            return None

    def findFileBinary (self,path):
        path = os.path.normcase (path)
        pp = os.path.join (self._path,path)
        if os.path.isfile(pp):
            return open(pp,'rb')
        else:
            return None
