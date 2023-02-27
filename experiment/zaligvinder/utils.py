import os
import shutil

class Result:
    def __init__(self,result,time,timeouted,smtcalls,output = "",model="",verified=None):
        self.result = result
        self.time = time
        self.timeouted = timeouted
        self.smtcalls = smtcalls
        self.output = output
        self.model = model
        self.verified = verified

        
class TrackInstance:
    def __init__ (self,name,filepath,exp  = None):
        self.name = name
        self.filepath = filepath
        self.expected = exp
        
class Track:
    def __init__ (self,trackname,instances = [],bname = None):
        self.name = trackname
        self.instances = instances
        self.benchmark = bname or trackname

    def __str__(self):
        return self.benchmark+ "/"+self.name
        
        
class ReferenceResult:
    def __init__(self,result,satissolvers,nsatissolvers):
        self.result=result
        self.satissolvers = satissolvers
        self.nsatissolvers = nsatissolvers
        
class ProgramLocator:
    def __init__(self):
        self._map = {
            'woorpje' : 'WOORPJEBINARY',
            'cvc4' : 'CVC4BINARY',
            'norn' : 'NORNBINARY',
            'woorpjeSMT' : 'WOORPJESMTBINARY',
            'Z3' : 'Z3BINARY',
            }
        
    def findProgram (self,toolname):
        environmentvar = self._map.get(toolname,toolname)
        return os.environ.get(environmentvar) or shutil.which (toolname) 

class JSONProgramConfig:
    def __init__(self,configfile = "./toolconfig.json"):
        import json
        with open(configfile) as config_file:
            data = json.load(config_file)
        self._tools = data["Binaries"]

    def findProgram (self,toolname):
        return self._tools[toolname]['path']
