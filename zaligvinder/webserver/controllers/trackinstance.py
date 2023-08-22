import webserver.views
import os

class TrackInstanceController:
    def __init__(self,instance):
        self._instance = instance

    def getAllInstances (self,params):
        instances = self._instance.loadAllInstances ()
        return webserver.views.jsonview.JSONView ([{"name" : tt.name,
                                                    "id" : tt.dbid,
                                                    "expected" : tt.expected
        } for tt in instances])
    
    def getInstanceModel (self,params):
        instance = self._instance.loadTrackInstance (params["instance"])
        if (os.path.isfile(instance.filepath)):
            file = open(instance.filepath)
            str = file.read()
            return webserver.views.TextView.TextView (str)
        else:
            return webserver.views.TextView.ErrorText ("Model not available")
