import utils

class Interface:
    def writeData (self,track,trackinstance,solvername,result):
        pass

    def postTrackUpdate (self,track,res):
        pass
    
class FileWriter:
    def __init__ (self,prefix = ""):
        from datetime import datetime
        timestamp = datetime.timestamp(datetime.now())
        self._outputfile = open(prefix+"_results_"+str(timestamp)+".csv",'w')
    
    def writeData (self,track,trackinstance,solvername,result):
        self._outputfile.write ("{6},{0},{1},{2},{3},{4},{5}\n".format (
            trackinstance.name,
            solvername,
            result.result,
            result.time,
            result.timeouted,
            result.smtcalls,
            track.name)
        )
        self._outputfile.flush ()

    def postTrackUpdate (self,track,res):
        pass
    
