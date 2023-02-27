import sys
import storage.sqlitedb
import webserver.views.jsonview
import webserver.controllers

db = storage.sqlitedb.DB (sys.argv[1])
trackinstance = storage.sqlitedb.TrackInstanceRepository (db)
track = storage.sqlitedb.TrackRepository(db,trackinstance)
results = storage.sqlitedb.ResultRepository (db,track,trackinstance)


    
tcontroller = webserver.controllers.TracksController (track)
icontroller = webserver.controllers.TrackInstanceController (trackinstance)
rcontroller = webserver.controllers.ResultController (results)
ccontroller = webserver.controllers.ChartController (results)
ccontrollerJS = webserver.controllers.ChartControllerJS (results)
import webserver.app




app = webserver.app.App ()
app.addEndpoint (webserver.routing.ExactMatch("tracks"),tcontroller.getAllTracks)
app.addEndpoint (webserver.routing.ExactMatch("instances"),icontroller.getAllInstances)
app.addEndpoint (webserver.routing.RegexMatch("instances/(?P<instance>\d+)/model.smt"),icontroller.getInstanceModel)
app.addEndpoint (webserver.routing.ExactMatch("results"),rcontroller.getAllResults)
app.addEndpoint (webserver.routing.ExactMatch("solvers"),rcontroller.getSolvers)
app.addEndpoint (webserver.routing.RegexMatch("results/(?P<track>\d+)"),rcontroller.getTrackResults)
app.addEndpoint (webserver.routing.RegexMatch("summary/(?P<solver>[^/]+)"),rcontroller.getSummaryForSolver)
app.addEndpoint (webserver.routing.ExactMatch("chart/cactus"),ccontroller.generateCactus)
app.addEndpoint (webserver.routing.RegexMatch("test"),ccontrollerJS.generateCactus)


app.run ()




                 
