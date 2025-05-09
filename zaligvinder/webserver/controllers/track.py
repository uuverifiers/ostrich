import webserver.views

class TracksController:
    def __init__ (self,track):
        self._track = track

    def getAllTracks (self,params):
        def constr (t):
            data = {"name" : t.name,
                    "id" : t.dbid,
                    "benchmark" : t.benchmark
            }
            trackfiles = []
            for tt  in t.instances:
                trackfiles.append ({"name" : tt.name,
                                    "id" : tt.dbid
                })
            data["instances"] = trackfiles
            return data
        res = self._track.loadAllTracks ()
        result = [constr(t) for t  in res]
        return webserver.views.jsonview.JSONView (result)

    def getAllTrackIds(self,params):
        ids = self._track.getAllTrackIds ()
        return webserver.views.jsonview.JSONView ([{"id" : tt[0]} for tt in ids])

    def getAllGroups(self,params):
        ids = self._track.getAllGroups ()
        return webserver.views.jsonview.JSONView ([{"id" : tt[0]} for tt in ids])


    def getStringOperationDataForTrack(self,params):
        if "track" in params:
            data = self._track.getStringOperationDataForTrack(params["track"])
            return webserver.views.jsonview.JSONView ([data])
        
        else: 
            return webserver.views.jsonview.JSONView ({"Error" : "No TrackId given!"})

    def getStringOperationDataForGroup(self,params):
        if "bgroup" in params:
            data = self._track.getStringOperationDataForGroup(params["bgroup"])
            return webserver.views.jsonview.JSONView ([data])
        
        else: 
            return webserver.views.jsonview.JSONView ({"Error" : "No Group name given!"})




