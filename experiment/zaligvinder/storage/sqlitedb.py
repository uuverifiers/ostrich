import sys
import sqlite3
import utils

class DB:
    def __init__(self,name):
        self.name = name
        self.conn = sqlite3.connect (name)

    def execute (self,query,inptuples = None):
        c = self.conn.cursor()
        if inptuples:
            c.execute (query,inptuples)
        else:
            c.execute (query)
        self.conn.commit ()
        
    def executeRet  (self,query,inptuples = None):
        c = self.conn.cursor()
        if inptuples:
            c.execute (query,inptuples)
        else:
            c.execute (query)
        return c.fetchall ()
        
class TrackInstanceRepository:
    def __init__ (self,db):
        self._db = db
        self._id = 1
        
    def createSchema (self):
        query = '''Create Table IF NOT EXISTS TrackInstance (id INTEGER PRIMARY KEY, name TEXT,filepath TEXT,expected BOOLEAN)'''
        self._db.execute (query)

    def storeInstance (self,trackinstance):
        if not hasattr (trackinstance,'dbid'):
            query = '''INSERT INTO TrackInstance (id,name,filepath,expected) Values (?,?,?,?)'''
            self._db.execute(query,(self._id,trackinstance.name,trackinstance.filepath,trackinstance.expected))
            trackinstance.dbid = self._id
            self._id = self._id+1
        else:
            query = '''UPDATE TrackInstance SET name = ?, filepath = ?, expected = ?  WHERE id = ?'''
            self._db.execute(query,(trackinstance.name,trackinstance.filepath,trackinstance.expected,trackinstance.dbid,))
        
        return trackinstance.dbid

    def loadTrackInstance (self,id):
        query = '''SELECT * FROM TrackInstance WHERE id = ?'''
        rows = self._db.executeRet (query,(id,))
        assert(len(rows)==1)
        tin = utils.TrackInstance (rows[0][1],rows[0][2],rows[0][3])
        tin.dbid = id
        return tin

    def loadAllInstances (self):
        query = '''SELECT id FROM TrackInstance '''
        rows = self._db.executeRet (query,)
        return [self.loadTrackInstance (id) for id, in rows]

class TrackRepository:
    def __init__ (self,db,instancerepo):
        self._db = db
        self._id = 1
        self.instancerepo = instancerepo
        
    def createSchema (self):
        query = '''Create Table  IF NOT EXISTS Track (id INTEGER PRIMARY KEY, name TEXT, bgroup TEXT)'''
        self._db.execute (query)
        query = '''Create Table IF NOT EXISTS TrackInstanceMap (track INTEGER, instance INTEGER)'''
        self._db.execute (query)
        
    def storeTrack (self,track):
        if not hasattr (track,'dbid'):
            query = '''INSERT INTO Track (id,name,bgroup) Values (?,?,?)'''
            self._db.execute(query,(self._id,track.name,track.benchmark))
            track.dbid = self._id
            self._id = self._id+1
            for inst in track.instances:
                tid = self.instancerepo.storeInstance (inst)
                query = '''INSERT INTO TrackInstanceMap (track,instance) Values (?,?)'''
                self._db.execute(query,(track.dbid,tid))
                
        return track.dbid

    def loadTrack (self,id):
        query = '''SELECT * FROM Track WHERE id = ?'''
        instancequery = '''SELECT * FROM TrackInstanceMap where track = ?'''
        rows = self._db.executeRet (query,(id,))
        assert(len(rows) == 1)
        tname = rows[0][1]
        bname = rows[0][2]
        rows = self._db.executeRet (instancequery,(id,))
        tinstances = [self.instancerepo.loadTrackInstance (instance) for (tid,instance) in rows]
        res = utils.Track (tname,tinstances,bname)
        res.dbid = id
        return res

    def loadAllTracks (self):
        query = '''SELECT id FROM Track'''
        rows = self._db.executeRet (query)
        res = [self.loadTrack (i) for i, in rows]
        return res

    def getAllTrackIds (self):
        query = '''SELECT Track.id FROM Track'''
        return self._db.executeRet(query,)

    def getAllGroups (self):
        query = '''SELECT DISTINCT Track.bgroup FROM Track'''
        return self._db.executeRet(query,)

    def getStringOperationDataForGroup(self,group,keywords=[]):
        query = '''SELECT Track.id FROM Track WHERE Track.bgroup = ?'''
        trackids = [t[0] for t in self._db.executeRet (query,(group,))]
        keywordDistribution = dict()
        for i,tid in enumerate(trackids):
            print("Processing " + str(i) + " of " + str(len(trackids)))
            keywordDistribution = self.getStringOperationDataForTrack(tid,keywords,keywordDistribution)
        return keywordDistribution

    def getStringOperationDataForTrack(self,trackid,keywords=[],keywordDistribution = dict()):
        query = '''SELECT TrackInstanceMap.instance FROM TrackInstanceMap WHERE TrackInstanceMap.track = ?'''
        rows = [t[0] for t in self._db.executeRet (query,(trackid,))]
        for iid in rows:
            keywordDistribution = self.getStringOperationDataForInstance(iid,keywords,keywordDistribution)
        return keywordDistribution

    def getStringOperationDataForInstance(self,instanceid,keywords=[],keywordDistribution = dict()):
        if len(keywords) == 0:
            keywords = ["str.++","str.len","str.<",
                "str.to.re","str.in.re",
                "str.<=","str.at","str.substr","str.prefixof","str.suffixof","str.contains","str.indexof","str.replace","str.is_digit","str.to.int","int.to.str"]

        query = '''SELECT TrackInstance.name, TrackInstance.filepath FROM TrackInstance WHERE TrackInstance.id = ?'''
        rows = self._db.executeRet (query,(instanceid,))
        for (name,filepath) in rows:
            rFilepath = filepath[filepath.rindex("models"):]
            keywordDistribution = self._getKeywordDistribution(rFilepath,keywords,keywordDistribution)
        return keywordDistribution

    def _getKeywordDistribution (self,filepath,keywords,keywordDistribution=dict()):
        """if set(keywordDistribution.keys()) != set(keywords):
            for k in keywords:
                keywordDistribution[k] = 0
        """
        f=open(filepath,"r")
        #print(filepath)
        for l in f:
            keywordDistribution = self._dynamicallyAquireKeywords(l,keywordDistribution)
            for k in keywordDistribution.keys():
                if k in l:
                    keywordDistribution[k]+=l.count(k)
        return keywordDistribution

    def _dynamicallyAquireKeywords(self,line,keywordDistribution):
        import re
        keywords = list(keywordDistribution.keys()) 
        for k in re.findall(r'\bstr\.[\S]+\s', line):
            if k not in keywords:
                keywordDistribution[k] = 0
        return keywordDistribution

class ResultRepository:
    def __init__ (self,db,trackrepo,instancerepo):
        self._db = db
        self.instancerepo = instancerepo
        self.trackrepo = trackrepo

    def createSchema (self):
        query = '''Create Table IF NOT EXISTS Result (solver TEXT, instanceid INTEGER, smtcalls INTEGER, timeouted BOOLEAN,result BOOLEAN,time INTEGER,output TEXT,model TEXT,verified BOOLEAN)'''       
        self._db.execute (query)

    def storeResult (self,result,solver,instance):
        query = '''INSERT INTO Result (solver,instanceid,smtcalls,timeouted,result,time,output,model,verified) VALUES(?,?,?,?,?,?,?,?,?)'''
        tid = self.instancerepo.storeInstance ( instance)
        self._db.execute (query,(solver,tid,result.smtcalls,result.timeouted,result.result,result.time,result.output,result.model,result.verified))

    def updateVerified(self,instanceid,solver,verified):
        query = '''UPDATE Result SET verified = ? WHERE solver = ? AND instanceid = ?'''
        self._db.execute(query,(verified,solver,instanceid,))

    def getSolvers (self):
        query = '''SELECT DISTINCT solver  FROM Result'''
        rows = self._db.executeRet (query)
        return [t[0] for  t in rows]

    def getSolversForTrack (self,trackid):
        query = '''SELECT DISTINCT solver  FROM Result,TrackInstanceMap WHERE Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = ?'''
        rows = self._db.executeRet (query,(trackid,))
        return [t[0] for  t in rows]

    def getSolversForGroup (self,bgroup):
        query = '''SELECT DISTINCT solver  FROM Result,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = Track.id AND Track.bgroup = ?'''
        rows = self._db.executeRet (query,(bgroup,))
        return [t[0] for  t in rows]

    def getTrackIds (self):
        query = '''SELECT DISTINCT track  FROM TrackInstanceMap'''
        rows = self._db.executeRet (query)
        return [t[0] for  t in rows]

    def getTrackNames (self):
        query = '''SELECT DISTINCT Track.id, Track.name  FROM Track'''
        rows = self._db.executeRet (query)
        return [(t[0],t[1]) for  t in rows]

    def getTrackInfo (self):
        query = '''SELECT *  FROM Track'''
        rows = self._db.executeRet (query)
        data = dict()
        for (tid,tname,bgroup) in rows:
            if bgroup not in data:
                data[bgroup] = []
            data[bgroup]+= [(tid,tname)]
        return data

    def getInstanceIdsForTrack(self,trackid):
        #print(trackid)
        query = '''SELECT DISTINCT TrackInstanceMap.instance  FROM TrackInstanceMap WHERE TrackInstanceMap.track = ?'''
        rows = self._db.executeRet (query,(int(trackid),))
        return [t[0] for t in rows] 


    def getInstanceIdsForGroup(self,bgroup):
        query = '''SELECT DISTINCT TrackInstanceMap.instance  FROM Track,TrackInstanceMap WHERE Track.bgroup = ? AND Track.id = TrackInstanceMap.track'''
        rows = self._db.executeRet (query,(bgroup,))
        return [t[0] for t in rows] 

    def getResultForSolver (self,solver):
        query = '''SELECT * FROM Result WHERE solver = ? ORDER BY time ASC '''
        rows = self._db.executeRet (query,(solver,))
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    def getResultForSolverInstance (self,solver,instanceid):
        query = '''SELECT * FROM Result WHERE solver = ? AND instanceid = ? ORDER BY time ASC '''
        rows = self._db.executeRet (query,(solver,instanceid))
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows][0]

    def getResultForSolverGroup (self,solver,group):
        query = '''SELECT * FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance and TrackInstanceMap.track = Track.id and Track.bgroup = ? ORDER BY time ASC '''
        rows = self._db.executeRet (query,(solver,group,))
        #print(rows)
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    def getResultForSolverGroupAndFilePath (self,solver,group):
        query = '''SELECT Result.*,TrackInstance.filepath FROM Result,TrackInstanceMap,Track,TrackInstance WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance and TrackInstanceMap.track = Track.id and Track.bgroup = ? and TrackInstance.id = TrackInstanceMap.instance ORDER BY time ASC '''
        rows = self._db.executeRet (query,(solver,group,))
        #print(rows)
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2]),t[9]) for t in rows]

    def getResultForSolverTrack (self,solver,track):
        query = '''SELECT Result.* FROM Result,TrackInstanceMap WHERE Result.solver = ? and Result.instanceid = TrackInstanceMap.instance and TrackInstanceMap.track = ? ORDER BY time ASC '''
        rows = self._db.executeRet (query,(solver,track))

        #for t in rows:
        #    print(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2]).result)


        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    def getInstanceNameToId(self,instanceid):
        query = '''SELECT TrackInstance.name FROM TrackInstance WHERE TrackInstance.id = ?'''
        row = self._db.executeRet (query,(str(instanceid),))
        return row[0][0]

    def getResultForSolverNoUnk (self,solver):
        query = '''SELECT * FROM Result,TrackInstance WHERE solver = ? and Result.result IS NOT NULL AND  Result.instanceid = TrackInstance.id AND TrackInstance.expected == Result.result AND Result.verified IS NOT false ORDER BY time ASC '''
        
        #ignore verifier
        #query = '''SELECT * FROM Result,TrackInstance WHERE solver = ? and Result.result IS NOT NULL AND  Result.instanceid = TrackInstance.id AND TrackInstance.expected == Result.result ORDER BY time ASC '''
        

        rows = self._db.executeRet (query,(solver,))
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    def getAllUnknownFilesForSolver(self,solver):
        query = '''SELECT TrackInstance.filepath FROM Result,TrackInstance WHERE solver = ? and Result.result IS NULL AND Result.timeouted IS FALSE AND Result.instanceid = TrackInstance.id ORDER BY time ASC ''' # AND Result.output  LIKE '%Error%' 
        
        rows = self._db.executeRet (query,(solver,))
        return [t[0] for t in rows]




    def getResultForSolverGroupNoUnk (self,solver,group):
        query = '''SELECT * FROM Result,TrackInstanceMap,Track,TrackInstance WHERE solver = ? AND TrackInstance.id = Result.instanceid AND TrackInstance.expected = Result.result AND Result.verified IS NOT false AND Result.result IS NOT NULL and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ?  ORDER BY time ASC '''
        
        # ignore verifier
        #query = '''SELECT * FROM Result,TrackInstanceMap,Track,TrackInstance WHERE solver = ? AND TrackInstance.id = Result.instanceid AND TrackInstance.expected = Result.result AND Result.result IS NOT NULL and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ?  ORDER BY time ASC '''
    
        rows = self._db.executeRet (query,(solver,group,))
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    def getResultForSolverTrackNoUnk (self,solver,track):
        query = '''SELECT Result.* FROM Result,TrackInstanceMap,TrackInstance WHERE Result.solver = ? AND TrackInstance.id = Result.instanceid AND TrackInstance.expected = Result.result AND Result.verified IS NOT false AND Result.result IS NOT NULL and Result.instanceid = TrackInstanceMap.instance and TrackInstanceMap.track = ? ORDER BY time ASC '''
        rows = self._db.executeRet (query,(solver,track))
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    
    def getAllResults (self):
            query = '''SELECT * FROM Result ORDER BY time ASC '''
            rows = self._db.executeRet (query)
            #print (rows)
            return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    def getBestSolverForInstance(self,instanceid):
        query = '''SELECT Result.solver FROM Result,TrackInstance WHERE Result.instanceid = TrackInstance.id AND Result.instanceid = ? AND Result.result IS NOT NULL AND Result.result = TrackInstance.expected ORDER BY time ASC ''' # TODO ADD Result.verified IS NOT false
        rows = [t[0] for t in self._db.executeRet (query,(instanceid,))]
        if len(rows) > 0:
            return rows[0]
        else:
            return None

    def getIdealSolverResultsForGroup(self,bgroup,solvers=[]):
        if len(solvers) == 0:
            query = '''SELECT Result.instanceid,Result.Result,MIN(Result.time) FROM Result,TrackInstanceMap,TrackInstance,Track WHERE Result.result IS NOT NULL AND Result.instanceid = TrackInstanceMap.instance and TrackInstanceMap.track = Track.id and TrackInstance.id = Result.instanceid and Track.bgroup = ? AND TrackInstance.expected = Result.result AND Result.verified IS NOT false GROUP BY Result.instanceid'''
            rows = [t for t in self._db.executeRet (query,(bgroup,))]
        else:
            placeholder= '?' # For SQLite. See DBAPI paramstyle.
            placeholders= ', '.join(placeholder for unused in solvers)
            querylist = [bgroup]+solvers
            query = 'SELECT Result.instanceid,Result.Result,MIN(Result.time) FROM Result,TrackInstanceMap,TrackInstance,Track WHERE Result.result IS NOT NULL AND Result.instanceid = TrackInstanceMap.instance and TrackInstanceMap.track = Track.id and TrackInstance.id = Result.instanceid and Track.bgroup = ? AND TrackInstance.expected = Result.result AND Result.verified IS NOT false AND Result.solver IN (%s) GROUP BY Result.instanceid' % placeholders
            rows = [t for t in self._db.executeRet (query,(querylist))]
        rows.sort(key=lambda t: t[2])

        return rows

    # faster classification
    def get2ComparisonTrackResultsFasterClassified(self,trackid,solver1,solver2):
        query = '''SELECT Result.solver, Result.instanceid, Result.timeouted, Result.result, TrackInstance.expected,Result.time FROM Result,TrackInstance,TrackInstanceMap WHERE Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = ? AND TrackInstance.id = Result.instanceid AND Result.solver = ?'''
        dataSolver1 = self._prepareClassificationData(self._db.executeRet (query, (trackid,solver1)))
        dataSolver2 = self._prepareClassificationData(self._db.executeRet (query, (trackid,solver2)))
    
        data = dict()
        for iid in dataSolver1:
            assert(len(dataSolver1[iid]) == 1 and len(dataSolver2[iid]) == 1)

            if dataSolver1[iid][0][2] or dataSolver2[iid][0][2]:
                continue


            if dataSolver1[iid][0][4] > dataSolver2[iid][0][4]+3.0:
                data[iid] = [dataSolver1[iid][0]] + [dataSolver2[iid][0]]
            #else: 
            #    data[iid] = [dataSolver2[iid][0]]
        return data

    # z3str3 ARM HACK
    def getArmsHack(self,trackid):
        query = '''SELECT Result.solver, Result.instanceid, Result.timeouted, Result.result, TrackInstance.expected,Result.time FROM Result,TrackInstance,TrackInstanceMap WHERE Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = ? AND TrackInstance.id = Result.instanceid AND Result.solver = ?'''
        dataPortfolio = self._prepareClassificationData(self._db.executeRet (query, (trackid,"z3str3-portfolio")))


        solverData = []
        time_gap = 3.0

        keywords = ["and","assert","not",
                    "str.++","str.len","str.<",
                    "str.to.re","str.in.re",
                    "str.<=","str.at","str.substr","str.prefixof","str.suffixof","str.contains","str.indexof","str.replace","str.is_digit","str.to.int","int.to.str",
                    "Bool","String","Int","("]


        for s in ["z3str2","z3seq","z3str3-length","z3str3-bv"]:
            solverData+=[self._prepareClassificationData(self._db.executeRet (query, (trackid,s)))]


        data = dict()


        for iid in dataPortfolio:
        
            new_best = False
            assert(len(dataPortfolio[iid]) == 1)

            #(solv,time,error,unkown)
            cur_port_data = [dataPortfolio[iid][0][0],dataPortfolio[iid][0][4],dataPortfolio[iid][0][2],dataPortfolio[iid][0][3]]

            if not cur_port_data[2]:
                best_data = cur_port_data.copy()
            else: 
                best_data = ["none",100.0,False,False]


            for i,sd in enumerate(solverData):
                if sd[iid][0][4]+time_gap < best_data[1] and not sd[iid][0][2]:
                    best_data = [sd[iid][0][0],sd[iid][0][4],sd[iid][0][2],sd[iid][0][3]]
                    new_best = True
                    best_id = i

            if new_best:
                queryInstance = '''SELECT filepath FROM TrackInstance WHERE id = ?'''
                filepath = self._db.executeRet (queryInstance, (iid,))[0][0]

                distribution = self.classifyInstance(filepath[len("/home/mku/wordbenchmarks/"):],keywords)
                distributionList = list(filter(lambda x: x[1] > 0, sorted(distribution.items(), key = lambda kv:(kv[1], kv[0]))))
                data[iid] = [dataPortfolio[iid][0]] + [solverData[best_id][iid][0]] + [distributionList]
 
        return data

    def instanceInformation(self,instanceid):
        keywords = ["Bool","String","Int"]
        queryInstance = '''SELECT filepath FROM TrackInstance WHERE id = ?'''
        filepath = self._db.executeRet (queryInstance, (instanceid,))[0][0]

        return self.classifyInstance(filepath[len("/home/mku/wordbenchmarks/"):],keywords)
        #distributionList = list(filter(lambda x: x[1] > 0, sorted(distribution.items(), key = lambda kv:(kv[1], kv[0]))))

    def getFilePath(self,instanceid):
        queryInstance = '''SELECT filepath FROM TrackInstance WHERE id = ?'''
        return self._db.executeRet (queryInstance, (instanceid,))[0][0]

    def classifyInstance (self,instance,keywords):
        keywordDistribution = dict()
        for k in keywords:
            keywordDistribution[k] = 0

        deepest_nest = 0
        current_nest = 0
        charcount = 0

        f=open(instance,"r")
        for l in f:
            charcount+=len(l)
            for k in keywords:
                if k in l:
                    keywordDistribution[k]+=l.count(k)

                #check nesting
                for a in l:
                    if a == "(":
                        current_nest+=1
                    elif a == ")":
                        if current_nest > deepest_nest:
                            deepest_nest = current_nest
                        current_nest=-1;

        keywordDistribution["deepest_nest"] = deepest_nest; 
        keywordDistribution["length"] = charcount

        return keywordDistribution
    ####

    def getTimeout(self):
        query = '''SELECT Result.time FROM Result WHERE Result.timeouted = true ORDER BY Result.time ASC'''
    
        rows = self._db.executeRet (query,)
        if len(rows) > 0:
            return [(t[0]) for t in rows][0]
        else: 
            return None

    def getTrackResults (self,trackid):
        query = '''SELECT Result.solver, Result.instanceid, Result.smtcalls, Result.timeouted, Result.result, Result.time FROM Result,Track,TrackInstanceMap WHERE Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = ? ORDER BY Result.time ASC'''
    
        rows = self._db.executeRet (query, (trackid,))
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    def getComparisonResultsForTrack(self,trackid,solvers):
        placeholders= ', '.join("?" for s in solvers)
        query = '''SELECT Result.solver, Result.instanceid, Result.smtcalls, Result.timeouted, Result.result, Result.time FROM Result,Track,TrackInstanceMap WHERE Result.solver IN (%s) AND Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = ? ORDER BY Result.time ASC''' % placeholders
    
        rows = self._db.executeRet (query, (solvers,trackid,))
        return [(t[0],t[1],utils.Result(t[4],t[5],t[3],t[2])) for t in rows]

    def getTrackInstancesClassification (self,trackid):
        query = '''SELECT Result.solver, Result.instanceid, Result.timeouted, Result.result, TrackInstance.expected,Result.time FROM Result,TrackInstance,TrackInstanceMap WHERE Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = ? AND TrackInstance.id = Result.instanceid'''
        return self._prepareClassificationData(self._db.executeRet (query, (trackid,)))

    def getGroupInstancesClassification (self,broup):
        query = '''SELECT Result.solver, Result.instanceid, Result.timeouted, Result.result, TrackInstance.expected,Result.time FROM Result,TrackInstance,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = Track.id AND Track.bgroup = ? AND TrackInstance.id = Result.instanceid'''
        return self._prepareClassificationData(self._db.executeRet (query, (broup,)))

    def _prepareClassificationData(self,rows):
        data = dict()
        for (solv,iid,to,res,exp,time) in rows:
            if iid not in data:
                data[iid] = []
            error = res != None and exp != res
            unk = not to and res == None
            data[iid]+=[(solv,to,error,unk,time)]
        return data

    # TODO: Remove Errors as soon as available and refactor
    def _getUniquelyClassifiedInstancesHelper(self,query,trackid=None):
        if trackid != None:
            rows = self._db.executeRet (query,(trackid))
        else:
            rows = self._db.executeRet (query)
        to_bool = lambda x: True if x==1 else False
        data = dict()

        for (solver,iid,res) in rows:
            if solver not in data:
                data[solver] = []
            data[solver]+=[(iid,to_bool(res))]
        return data

    def getUniquelyClassifiedInstances(self):
        query = '''SELECT Result.solver, Result.instanceid, Result.result FROM Result WHERE Result.result IS NOT NULL GROUP BY Result.instanceid,Result.result HAVING COUNT(Result.result) = 1'''
        return self._getUniquelyClassifiedInstancesHelper(query)

    def getUniquelyClassifiedInstancesForTrack(self,trackid):
        query = '''SELECT Result.solver, Result.instanceid, Result.result FROM Result,TrackInstanceMap WHERE Result.instanceid = TrackInstanceMap.instance AND TrackInstanceMap.track = ? AND Result.result IS NOT NULL GROUP BY Result.instanceid,Result.result HAVING COUNT(Result.result) = 1'''
        return self._getUniquelyClassifiedInstancesHelper(query,str(trackid))

    def getInstanceResultForSolvers(self,instanceid,solvers):
        paramsStr = ', '.join("?" for s in solvers)
        querylist = [instanceid] + solvers
        query = '''SELECT Result.*,TrackInstance.expected,TrackInstance.Name FROM Result,TrackInstance WHERE Result.instanceid = ? AND Result.instanceid = TrackInstance.id  AND Result.solver IN (%s) ORDER BY time ASC ''' % paramsStr
        rows = self._db.executeRet (query,(querylist))
        return [(t[0],t[1],t[9], t[10], utils.Result(t[4],t[5],t[3],t[2],t[6],t[7],t[8]),t[6]) for t in rows]
        
    def getSummaryForSolver (self,solver):
        query = '''SELECT SUM(Result.smtcalls), SUM(Result.timeouted), SUM(Result.time),COUNT(*) FROM Result WHERE solver = ?'''
        rows = self._db.executeRet (query, (solver,))
        smtcalls,timeouted,time,total = rows[0]
        assert(len(rows) == 1)

        satisquery = ''' SELECT COUNT(*) FROM Result WHERE Solver = ? AND Result.result = true'''
        satis = self._db.executeRet (satisquery, (solver,))[0][0]

        unkquery = ''' SELECT COUNT(*) FROM Result WHERE Solver = ? AND Result.result IS NULL'''
        unk = self._db.executeRet (unkquery, (solver,))[0][0]

        nsatisquery = ''' SELECT COUNT(*) FROM Result WHERE Solver = ? AND Result.result = false'''
        nsatis = self._db.executeRet (nsatisquery, (solver,))[0][0]

        errorquery = ''' SELECT COUNT(*) FROM Result,TrackInstance WHERE solver = ? AND Result.result != TrackInstance.expected AND Result.result IS NOT NULL AND TrackInstance.id = Result.instanceid ''' 
        errors = self._db.executeRet (errorquery, (solver,))[0][0]
        
        
        return (smtcalls,timeouted,satis,unk,nsatis,errors,time,total) 

    def getBestWoorpjeSolvers(self,solvers,group=None,woorpjePrefix="woorpje-"):
        allSolvers = self.getSolvers()
        bestSolvers = []
        print(allSolvers)
        for s in solvers:
            best = None
            for os in [ss for ss in allSolvers if ss.startswith(woorpjePrefix+s) and not ss.endswith("N")]:
                print(os)
                if group == None:
                    t = self.getSummaryForSolver(os)
                else:
                    t = self.getSummaryForSolverGroup(os,group)
                classified = (t[2]+t[4])-t[5]
                if best == None or best[1] < classified:
                    best = (os,classified)
            bestSolvers+=[best[0]]

        return bestSolvers

    def getPureWoorpjeSolvers(self,woorpjePrefix="woorpje-"):
        return [s for s in self.getSolvers() if s.startswith(woorpjePrefix) and s.endswith("N")]

    def getSummaryForSolverGroup (self,solver,group):
        query = '''SELECT SUM(Result.smtcalls), SUM(Result.timeouted), SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? '''
            
        rows = self._db.executeRet (query, (solver,group,))
        smtcalls,timeouted,time,total = rows[0]
        assert(len(rows) == 1)

        satisquery = ''' SELECT COUNT(*) FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ?  AND Result.result = true'''
        satis = self._db.executeRet (satisquery, (solver,group,))[0][0]

        unkquery = ''' SELECT COUNT(*) FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  AND Result.timeouted = false and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.result IS NULL'''
        unk = self._db.executeRet (unkquery, (solver,group,))[0][0]

        nsatisquery = ''' SELECT COUNT(*)  FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.result = false'''
        nsatis = self._db.executeRet (nsatisquery, (solver,group,))[0][0]

        errorquery = ''' SELECT COUNT(*) FROM Result,TrackInstance,TrackInstanceMap,Track WHERE Result.solver = ? AND Result.result IS NOT NULL AND Result.instanceid = TrackInstance.id AND (TrackInstance.expected != Result.result OR (TrackInstance.expected = Result.result AND Result.verified = false)) AND TrackInstance.id = TrackInstanceMap.instance AND TrackInstanceMap.track = Track.id AND Track.bgroup = ?''' 
        errors = self._db.executeRet (errorquery, (solver,group,))[0][0]



        return (smtcalls,timeouted,satis,unk,nsatis,errors,time,total) 


    # OLD LEGACY function
    def getSummaryForSolverGroupTotalTimeWOTimeout(self,solver,group):
        (smtcalls,timeouted,satis,unk,nsatis,errors,time,total) = self.getSummaryForSolverGroup(solver,group)

        #query = '''SELECT SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap,TrackInstance,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.timeouted = false AND Result.instanceid = TrackInstance.id AND (TrackInstance.expected = Result.result OR Result.result = NULL)'''
        query = '''SELECT SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.timeouted = false'''
        row = self._db.executeRet (query, (solver,group,))
        timeWO,totalWO = row[0]

        if timeWO == None:
            timeWO = 0.0

        return (smtcalls,timeouted,satis,unk,nsatis,errors,time,total,timeWO,totalWO)

    def getSummaryForSolverGroupXP(self,solver,group):
        (smtcalls,timeouted,satis,unk,nsatis,errors,time,total) = self.getSummaryForSolverGroup(solver,group)
        
        query = '''SELECT SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.timeouted = false'''
        row = self._db.executeRet (query, (solver,group,))

        solvedQuery = '''SELECT SUM(Result.time)FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.timeouted = false AND Result.result IS NOT NULL'''
        solvedTime = self._db.executeRet (query, (solver,group,))[0][0]
        
        
        crashquery = ''' SELECT COUNT(*) FROM Result,TrackInstanceMap,Track WHERE Result.solver = ? AND Result.result IS NULL AND Result.output LIKE '%SIG%' and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? ''' ### TODO ADD VERIFIED!!!
        crashs = self._db.executeRet (crashquery, (solver,group))[0][0]

        verifiedquery = '''SELECT COUNT(*) FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.verified = true'''
        verified = self._db.executeRet (verifiedquery, (solver,group,))[0][0]

        timeWO,totalWO = row[0]

        if timeWO == None:
            timeWO = 0.0

        return {"smtcalls" : smtcalls, "timeouted": timeouted, "sat" : satis, "unsat" : nsatis, "unknown" : unk, "verified" : verified, "errors" : errors, "crashes" : crashs, "time" : time, "timeWO" : timeWO, "total" : total, "totalWO" : totalWO, "totalSolvedTime" : solvedTime}



    def getVerifiedCountForSolverGroup(self,solver,group):
        query = '''SELECT COUNT(*) FROM Result,TrackInstanceMap,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.verified = true'''
        return self._db.executeRet (query, (solver,group,))[0][0]


    # demo
    def getUnverifiedSATInstances(self,solver):
        query = '''SELECT Result.instanceid, TrackInstance.filepath FROM Result, TrackInstance WHERE Result.solver = ? AND Result.result = true AND Result.verified = false AND Result.instanceid = TrackInstance.id'''
        rows = self._db.executeRet (query,(solver,))
        return {t[0] : {"filepath" : t[1]} for t in rows}


    # ast 2nd
    def getVerifiedAndCVC4 (self):
            query = '''SELECT Instances.result, TrackInstance.* FROM TrackInstance, (SELECT instanceid,result FROM Result WHERE (verified == true and result == true) or (solver == "CVC4" and result == false) GROUP BY instanceid) AS Instances WHERE TrackInstance.id = Instances.instanceid'''# '''
            rows = self._db.executeRet (query)
            #print (rows)
            return {t[1] : {'path' : t[3], 'result' : t[0], 'set' : t[3].split("/")[-3],'track' : t[3].split("/")[-2],'instance' : t[3].split("/")[-1]} for t in rows}

    # quick hack...
    def getSummaryForSolverTable(self,solver):
        query = '''SELECT SUM(Result.smtcalls), SUM(Result.timeouted), SUM(Result.time),COUNT(*) FROM Result WHERE solver = ?'''
        rows = self._db.executeRet (query, (solver,))
        smtcalls,timeouted,time,total = rows[0]
        assert(len(rows) == 1)

        queryWO = '''SELECT SUM(Result.time),COUNT(*) FROM Result WHERE solver = ? AND Result.timeouted = false'''
        rowWO = self._db.executeRet (queryWO, (solver,))
        timeWO,totalWO = rowWO[0][0],rowWO[0][1]


        satisquery = ''' SELECT COUNT(*) FROM Result WHERE solver = ? AND Result.result = true'''
        satis = self._db.executeRet (satisquery, (solver,))[0][0]

        unkquery = ''' SELECT COUNT(*) FROM Result WHERE solver = ? AND Result.timeouted = false AND Result.result IS NULL'''
        unk = self._db.executeRet (unkquery, (solver,))[0][0]

        nsatisquery = ''' SELECT COUNT(*)  FROM Result WHERE solver = ? AND Result.result = false'''
        nsatis = self._db.executeRet (nsatisquery, (solver,))[0][0]

        errorquery = ''' SELECT COUNT(*) FROM Result,TrackInstance WHERE Result.solver = ? AND Result.result IS NOT NULL AND Result.instanceid = TrackInstance.id AND TrackInstance.expected != Result.result''' ### TODO ADD VERIFIED!!!
        errors = self._db.executeRet (errorquery, (solver,))[0][0]


        invalidquery = ''' SELECT COUNT(*) FROM Result,TrackInstance WHERE Result.solver = ? AND Result.result IS NOT NULL AND Result.instanceid = TrackInstance.id AND Result.verified = false''' ### TODO ADD VERIFIED!!!
        invalid = self._db.executeRet (invalidquery, (solver,))[0][0]

        crashquery = ''' SELECT COUNT(*) FROM Result WHERE Result.solver = ? AND Result.result IS NULL AND Result.output LIKE '%SIG%' ''' ### TODO ADD VERIFIED!!!
        crashs = self._db.executeRet (crashquery, (solver,))[0][0]

        return {"smtcalls" : smtcalls, "timeout" : timeouted, "sat" : satis, "unsat" : nsatis, "unk" : unk, "error" : errors, "invalid": invalid, "crash" : crashs, "time" : round(time, 2), "total" : total, "totalWO" : totalWO, "timeWO" : round(timeWO,2)}

    def getSummaryForSolverGroupTable(self,solver,group):
        query = '''SELECT SUM(Result.smtcalls), SUM(Result.timeouted), SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND solver = ? '''
        rows = self._db.executeRet (query, (group,solver,))
        smtcalls,timeouted,time,total = rows[0]
        assert(len(rows) == 1)

        queryWO = '''SELECT SUM(Result.time),COUNT(*) FROM Result ,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND solver = ? AND Result.timeouted = false'''
        rowWO = self._db.executeRet (queryWO, (group,solver,))
        timeWO,totalWO = rowWO[0][0],rowWO[0][1]


        satisquery = ''' SELECT COUNT(*) FROM Result ,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND solver = ? AND Result.result = true'''
        satis = self._db.executeRet (satisquery, (group,solver,))[0][0]

        unkquery = ''' SELECT COUNT(*) FROM Result ,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND solver = ? AND Result.timeouted = false AND Result.result IS NULL'''
        unk = self._db.executeRet (unkquery, (group,solver,))[0][0]

        nsatisquery = ''' SELECT COUNT(*)  FROM Result ,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND solver = ? AND Result.result = false'''
        nsatis = self._db.executeRet (nsatisquery, (group,solver,))[0][0]

        errorquery = ''' SELECT COUNT(*) FROM Result,TrackInstance ,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.solver = ? AND Result.result IS NOT NULL AND Result.instanceid = TrackInstance.id AND TrackInstance.expected != Result.result''' ### TODO ADD VERIFIED!!!
        errors = self._db.executeRet (errorquery, (group,solver,))[0][0]


        invalidquery = ''' SELECT COUNT(*) FROM Result,TrackInstance ,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.solver = ? AND Result.result IS NOT NULL AND Result.instanceid = TrackInstance.id AND Result.verified = false''' ### TODO ADD VERIFIED!!!
        invalid = self._db.executeRet (invalidquery, (group,solver,))[0][0]

        crashquery = ''' SELECT COUNT(*) FROM Result ,TrackInstanceMap,Track WHERE Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.solver = ? AND Result.result IS NULL AND Result.output LIKE '%SIG%' ''' ### TODO ADD VERIFIED!!!
        crashs = self._db.executeRet (crashquery, (group,solver,))[0][0]

        return {"smtcalls" : smtcalls, "timeout" : timeouted, "sat" : satis, "unsat" : nsatis, "unk" : unk, "error" : errors, "invalid": invalid, "crash" : crashs, "time" : time, "total" : total, "totalWO" : totalWO, "timeWO" : timeWO}



    def getOutputForSolverInstance (self,solver,instance):
        query = '''SELECT output  FROM Result WHERE solver = ? AND instanceid = ?'''
        out = self._db.executeRet (query,(solver,instance))[0][0]
        if hasattr(out,'decode'):
            return out.decode('utf8')
        else:
            return self._db.executeRet (query,(solver,instance))[0][0]


    def getModelForSolverInstance (self,solver,instance):
        query = '''SELECT model  FROM Result WHERE solver = ? AND instanceid = ?'''
        out = self._db.executeRet (query,(solver,instance))[0][0]
        if hasattr(out,'decode'):
            return out.decode('utf8')
        else:
            return self._db.executeRet (query,(solver,instance))[0][0]
    
        
    def getSummaryForSolverTrack (self,solver,track):
        query = '''SELECT SUM(Result.smtcalls), SUM(Result.timeouted), SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap WHERE solver = ? AND TrackInstanceMap.track = ? AND TrackInstanceMap.instance = Result.instanceid'''
        rows = self._db.executeRet (query, (solver,str(track)))
        assert(len(rows) == 1)                
        smtcalls,timeouted,time,total = rows[0]

        satisquery = ''' SELECT COUNT(*) FROM Result,TrackInstanceMap WHERE Solver = ? AND Result.result = true AND TrackInstanceMap.track = ? AND TrackInstanceMap.instance = Result.instanceid'''
        satis = self._db.executeRet (satisquery, (solver,track))[0][0]

        unkquery = ''' SELECT COUNT(*) FROM Result,TrackInstanceMap WHERE Solver = ? AND Result.result IS NULL AND Result.timeouted = false AND TrackInstanceMap.track = ? AND TrackInstanceMap.instance = Result.instanceid'''
        unk = self._db.executeRet (unkquery, (solver,track))[0][0]

        nsatisquery = ''' SELECT COUNT(*) FROM Result,TrackInstanceMap WHERE Solver = ? AND Result.result = false AND TrackInstanceMap.track = ? AND TrackInstanceMap.instance = Result.instanceid'''
        nsatis = self._db.executeRet (nsatisquery, (solver,track))[0][0]

        errorquery = ''' SELECT COUNT(*) FROM Result,TrackInstance,TrackInstanceMap WHERE Result.solver = ? AND Result.result IS NOT NULL AND Result.instanceid = TrackInstance.id AND (TrackInstance.expected != Result.result OR (TrackInstance.expected = Result.result AND Result.verified = false)) AND TrackInstance.id = TrackInstanceMap.instance AND TrackInstanceMap.track = ?''' 
        errors = self._db.executeRet (errorquery, (solver,track))[0][0]

        #total = timeouted+satis+unk+nsatis+errors

        #print("LOL")
        
        return (smtcalls,timeouted,satis,unk,nsatis,errors,time,total)

    def getSummaryForSolverTrackTotalTimeWOTimeout(self,solver,track):
        (smtcalls,timeouted,satis,unk,nsatis,errors,time,total) = self.getSummaryForSolverTrack(solver,track)

        #query = '''SELECT SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap,TrackInstance,Track WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = Track.id and Track.bgroup = ? AND Result.timeouted = false AND Result.instanceid = TrackInstance.id AND (TrackInstance.expected = Result.result OR Result.result = NULL)'''
        query = '''SELECT SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = ? AND Result.timeouted = false'''
        row = self._db.executeRet (query, (solver,track,))
        timeWO,totalWO = row[0]

        if timeWO == None:
            timeWO = 0.0

        return (smtcalls,timeouted,satis,unk,nsatis,errors,time,total,timeWO,totalWO)

    def getSummaryForSolverTrackXP(self,solver,track):
        (smtcalls,timeouted,satis,unk,nsatis,errors,time,total) = self.getSummaryForSolverTrack(solver,track)
        
        query = '''SELECT SUM(Result.time),COUNT(*) FROM Result,TrackInstanceMap WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = ? AND Result.timeouted = false'''
        row = self._db.executeRet (query, (solver,track,))

        solvedQuery = '''SELECT SUM(Result.time)FROM Result,TrackInstanceMap WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = ? AND Result.timeouted = false AND Result.result IS NOT NULL'''
        solvedTime = self._db.executeRet (query, (solver,track,))[0][0]
        
        
        crashquery = ''' SELECT COUNT(*) FROM Result,TrackInstanceMap WHERE Result.solver = ? AND Result.result IS NULL AND Result.output LIKE '%SIG%' and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = ? ''' ### TODO ADD VERIFIED!!!
        crashs = self._db.executeRet (crashquery, (solver,track))[0][0]

        verifiedquery = '''SELECT COUNT(*) FROM Result,TrackInstanceMap WHERE solver = ? and Result.instanceid = TrackInstanceMap.instance  and TrackInstanceMap.track = ? AND Result.verified = true'''
        verified = self._db.executeRet (verifiedquery, (solver,track,))[0][0]

        timeWO,totalWO = row[0]

        if timeWO == None:
            timeWO = 0.0

        return {"smtcalls" : smtcalls, "timeouted": timeouted, "sat" : satis, "unsat" : nsatis, "unknown" : unk, "verified" : verified, "errors" : errors, "crashes" : crashs, "time" : time, "timeWO" : timeWO, "total" : total, "totalWO" : totalWO, "totalSolvedTime" : solvedTime}




    def getReferenceForInstance (self,instance):
        query = '''SELECT result,Solver FROM Result WHERE instanceid = ? '''
        rows = self._db.executeRet (query, (instance,))
        sat = []
        nsat = []
        for r in rows:
            if r[0] == True:
                sat.append(r[1])
            elif r[1] == False:
                nsat.append(r[1])
        res = None
        if len(sat) > len(nsat):
            res = True
        elif len(nsat) > len(sat):
            res = False
        return utils.ReferenceResult (res,sat,nsat)

    def getErrosForSolverGroup (self,solver,group):
        errorquery = ''' SELECT Result.solver, Track.bgroup, Track.name, TrackInstance.name, TrackInstance.filepath, Result.time, Result.result, TrackInstance.expected, Result.model, Result.verified, Result.output TrackInstance FROM Result,TrackInstance,TrackInstanceMap,Track WHERE Result.solver = ? AND Result.instanceid = TrackInstance.id AND Result.timeouted = false AND TrackInstance.id = TrackInstanceMap.instance AND TrackInstanceMap.track = Track.id AND Track.bgroup = ? AND ( ((TrackInstance.expected != Result.result OR Result.verified = false) AND Result.result IS NOT NULL) OR Result.output LIKE '%Error%')''' 
        errors = self._db.executeRet (errorquery, (solver,group,))
        return errors

    def getAllUnverifiedSATForSolverGroup(self,solver,group):
        errorquery = ''' SELECT Result.solver, Track.bgroup, Track.name, TrackInstance.name, TrackInstance.filepath, Result.time, Result.result, TrackInstance.expected, Result.model, Result.verified, Result.output TrackInstance FROM Result,TrackInstance,TrackInstanceMap,Track WHERE Result.solver = ? AND Result.instanceid = TrackInstance.id AND Result.timeouted = false AND TrackInstance.id = TrackInstanceMap.instance AND TrackInstanceMap.track = Track.id AND Track.bgroup = ? AND Result.result = true and Result.verified IS NULL''' 
        errors = self._db.executeRet (errorquery, (solver,group,))
        return errors


        
    def getInstancesCount (self):
        query = '''SELECT COUNT(*) FROM TrackInstance'''
        return [t[0] for t in self._db.executeRet (query)][0]
        

        
class SQLiteDB:
    def __init__ (self,prefix = ""):
        from datetime import datetime
        timestamp = datetime.timestamp(datetime.now())
        self._db = DB(prefix+"_results_"+str(timestamp)+".db")
        self._instancerepo = TrackInstanceRepository (self._db)
        self._trackrepo = TrackRepository (self._db,self._instancerepo)
        self._resrepo = ResultRepository (self._db,self._trackrepo,self._instancerepo)
        for i in [self._instancerepo,self._trackrepo,self._resrepo]:
            i.createSchema ()

    def getDB (self):
        return self._db
            
    def writeData (self,track,trackinstance,solvername,result):
        self._trackrepo.storeTrack (track)
        self._resrepo.storeResult (result,solvername,trackinstance)
    
    def progressMessage (self,cur,total):
        sys.stdout.write ("\x1b[2K\r[ Update database  - {0}/{1} ]".format(cur+1,total))


    def postTrackUpdate (self,track,res):
        sys.stdout.write("Starting post track update!\n")
        totalCount = len(track.instances)
        for i,t in enumerate(track.instances):
            self.progressMessage(i,totalCount)
            iid = self._instancerepo.storeInstance(t)
            #for s in res:
            #    if res[s][i].result == True:
            #        self._resrepo.updateVerified(iid,s,res[s][i].verified)
        sys.stdout.write("\n")        

