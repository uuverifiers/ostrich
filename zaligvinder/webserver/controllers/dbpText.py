import webserver.views.charts.base
import webserver.files

class DBPTest:
    def __init__(self,result):
        self._result = result

    def cdl_entry(self,params):
        solvers = self._result.getSolvers ()
        data = self._result.getTrackInfo ()
        instanceCount = self._result.getInstancesCount()
        benchmarks = data.keys()
        tracks = []

        for b in benchmarks:
            tracks += data[b]

        return webserver.views.charts.base.EntryView (benchmarks,tracks,solvers,instanceCount)
        
    def cdl_test (self,params):
        #solvers = self._result.getSolvers ()
        data = self._result.getTrackInfo ()
        benchmarks = data.keys()
        if "bgroup" in params:
            activeGroup = params["bgroup"][0]
        else:
            activeGroup = list(data.keys())[0]

        #tracks = data[activeGroup]
        ctrack = int(params.get("track",[1])[0])
        trackname = None
        for tid,name in data[activeGroup]:
            #print (tid,ctrack)
            if tid == ctrack:
                trackname = name
                break


        if trackname != None:
            solvers = self._result.getSolversForTrack(ctrack)
        else:
            solvers = self._result.getSolversForGroup(activeGroup)


        tracksmap = dict()
        for bgroup in data:
            if bgroup not in tracksmap: 
                tracksmap[bgroup] = []
                tracksmap[bgroup] = [("Summary","?bgroup={}&track={}".format(bgroup,0))]+[(tup[1],"?bgroup={}&track={}".format(bgroup,tup[0])) for tup in data[bgroup]]

        return webserver.views.charts.base.BenchmarkTrackView (
            [(n,"?bgroup={}".format(n)) for n in benchmarks],
            tracksmap,
            activeGroup,
            trackname,
            ctrack,
            solvers
        )

    def cdl_comparison (self,params):
        #solvers = self._result.getSolvers ()
        data = self._result.getTrackInfo ()
        benchmarks = data.keys()
        if "bgroup" in params:
            activeGroup = params["bgroup"][0]
        else:
            activeGroup = list(data.keys())[0]



        #tracks = data[activeGroup]
        ctrack = int(params.get("track",[1])[0])
        trackname = None
        for tid,name in data[activeGroup]:
            #print (tid,ctrack)
            if tid == ctrack:
                trackname = name
                break

        if trackname != None:
            solvers = self._result.getSolversForTrack(ctrack)
        else:
            solvers = self._result.getSolversForGroup(activeGroup)



        if "solvers" in params:
            activeSolvers = params["solvers"]
        else: 
            activeSolvers = [solvers[0]]


        tracksmap = dict()
        for bgroup in data:
            if bgroup not in tracksmap: 
                tracksmap[bgroup] = []
                tracksmap[bgroup] = [("Summary","?bgroup={}&track={}".format(bgroup,0))]+[(tup[1],"?bgroup={}&track={}".format(bgroup,tup[0])) for tup in data[bgroup]]

        if ctrack != 0:
            instanceIds = self._result.getInstanceIdsForTrack(ctrack)
        else:
            instanceIds = self._result.getInstanceIdsForGroup(activeGroup)

        return webserver.views.charts.base.BenchmarkComparisonView (
            [(n,"?bgroup={}".format(n)) for n in benchmarks],
            tracksmap,
            activeGroup,
            trackname,
            ctrack,
            activeSolvers,
            solvers,
            instanceIds
        )
            
