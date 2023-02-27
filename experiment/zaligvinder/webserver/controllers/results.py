import webserver.views


class ResultController:
    def __init__(self,results,track):
        self._results = results
        self._track = track

    def getSummaryForSolver (self,params):
        res = {}
        #print (params)
        
        s = params["solver"]
        smtcalls,timeouted,satis,unk,nsatis,errors,time,instances = self._results.getSummaryForSolver (s)
        res["Summary"] = {
            'solver' : s,
            'smtcalls' : smtcalls,
            'timeouted' : timeouted,
            'satisfied' : satis,
            'not satisfied' :  nsatis,
            'error' : errors,
            'Unknown' : unk,
            'time' : "%.2f" % time,
            'instances' : instances
            }
        return webserver.views.jsonview.JSONView (res)

    def getSummaryForSolverTrack (self,params):
        res = {}
        
        s = params["solver"]
        track = int(params["track"])
        bgroup = params.get("bgroup",[""])[0]
        #print ("PPPP",track,bgroup)
        smtcalls,timeouted,satis,unk,nsatis,errors,time,instances = self._results.getSummaryForSolverTrack (s,track) if track != 0 else self._results.getSummaryForSolverGroup (s,bgroup)
        res["Summary"] = {
            'solver' : s,
            'smtcalls' : smtcalls,
            'timeouted' : timeouted,
            'satisfied' : satis,
            'not satisfied' :  nsatis,
            'error': errors,
            'Unknown' : unk,
            'time' : "%.2f" % time,
            'instances' : instances
            }
        return webserver.views.jsonview.JSONView (res)

    def getRanks(self,params):
        timout = 20


        if "track" in params and int(params["track"]) != 0:
            data = self._results.getTrackInstancesClassification (params["track"])
        else:
            groups = list(self._results.getTrackInfo ().keys())
            if "bgroup" in params and params["bgroup"][0] in groups:
                bgroup = params["bgroup"][0]
            else:
                bgroup =  groups[0]
            data = self._results.getGroupInstancesClassification (bgroup)


        summaryData = dict()
        for iid in data:
            sortedData = sorted(data[iid], key=lambda tup: tup[4])
            for (solv,to,error,unk,time) in sortedData:
                i = 0
                if solv not in summaryData:
                    summaryData[solv] = 0

                """
                # Points:
                # Timeouted: -1 point
                # Error: -5 Points
                # Unknown: 1 point
                # correct: 5 points / classification positon

                # stupid inlining :/
                if to:
                    summaryData[solv]-=1
                elif error:
                    summaryData[solv]-=5
                elif unk:
                    summaryData[solv]+=1
                else:
                    i+=1
                    summaryData[solv]+=(int(5/(i+1)))
                """


                ### PAR 2 Score
                # The solvers will ranked using the PAR-2 scheme: The score of a solver is defined as the sum of all runtimes for solved instances + 2*timeout for unsolved instances, lowest score wins.



                if not to and not unk and not error:
                    summaryData[solv]+=time
                elif error:
                    summaryData[solv]+=(timout*5)
                else:
                    summaryData[solv]+=(timout*2)

        return webserver.views.jsonview.JSONView ([{"solver" : solv,
                                                    "points" : round(points,2),
                                                }
                                                   for solv, points in sorted(summaryData.items(), key=lambda item: item[1], reverse=False)])


    def getReferenceResult (self,params):
        ref = self._results.getReferenceForInstance (params["instance"])
        res = {'result' : ref.result,
               'satisfying solvers' : ref.satissolvers,
               'nsatisfying solvers' : ref.nsatissolvers
        }
        return webserver.views.jsonview.JSONView (res)
    
    def getAllResults (self,params):
        instances = self._results.getAllResults ()
        
        return webserver.views.jsonview.JSONView ([{"solver" : tt[0],
                                                    "instanceid" : tt[1],
                                                    "Result" : {
                                                        "smtcalls" : tt[2].smtcalls,
                                                        "timeouted" : tt[2].timeouted,
                                                        "result" : tt[2].result,
                                                        "time" : "%.2f" % tt[2].time}
                                                    }
                                                     for tt in instances])
    
    def getOutput (self,params):
        #print (params)
        instances = self._results.getOutputForSolverInstance (params["solver"],params["instance"])
        return webserver.views.TextView.TextView (instances)

    def getModel (self,params):
        #print (params)
        instances = self._results.getModelForSolverInstance (params["solver"],params["instance"])
        return webserver.views.TextView.TextView (instances)
    
    
    def getTrackResults (self,params):
        if "track" in params:
            assert(len(params) == 1)
            instances = self._results.getTrackResults (params["track"])
            return webserver.views.jsonview.JSONView ([{"solver" : tt[0],
                                                        "instanceid" : tt[1],
                                                        "Result" : {
                                                            "smtcalls" : tt[2].smtcalls,
                                                            "timeouted" : tt[2].timeouted,
                                                            "result" : tt[2].result,
                                                        "time" : "%.2f" % tt[2].time}
                                                    }
                                                       for tt in instances])
        else:
            return webserver.views.jsonview.JSONView ({"Error" : "Missing parameter"})
        
    def getSolvers (self,params):
        return webserver.views.jsonview.JSONView (self._results.getSolvers ())

    def getInstanceIdsForTrack(self,params):
        if "track" in params:
            assert(len(params) == 1)
            instances = self._results.getInstanceIdsForTrack (params["track"])
            return webserver.views.jsonview.JSONView ([{"id" : tt[0]} for tt in instances])
        else:
            return webserver.views.jsonview.JSONView ({"Error" : "Missing parameter"})

    def getInstanceIdsForGroup(self,params):
        if "bgroup" in params:
            assert(len(params) == 1)
            instances = self._results.getInstanceIdsForGroup (params["bgroup"])
            return webserver.views.jsonview.JSONView ([{"id" : tt[0]} for tt in instances])
        else:
            return webserver.views.jsonview.JSONView ({"Error" : "Missing parameter"})

    def getTrackInfo(self,params):
        return webserver.views.jsonview.JSONView (self._results.getTrackInfo ()) 

    def _mapResultToIcon(self,result):
        iconMap = {0 : "times", 1 : "check", None : "unknown-status"}
        if result in iconMap:
            return iconMap[result]
        else:
            return "exclamation-triangle"

    def getResultForSolvers(self,params):
        if "solvers" in params and "instance" in params:
            iid = params["instance"]
            results = self._results.getInstanceResultForSolvers(iid,params["solvers"])
            data = dict()
            data[iid] = dict()
            resultSet = False
            expectedResult = None
            expectedResultSet = False
            instanceName = ""
            errorFound = 0
            classifications = []
            answers = [0,0]

            for tt in results:
                if expectedResult == None and not expectedResultSet:   
                    expectedResult = tt[2]   
                    if expectedResult != None:
                        expectedResultSet = True
                    instanceName = tt[3]
                error = 1 if ((expectedResult != tt[4].result and expectedResultSet) or (tt[4].result == True and tt[4].verified == False)) and tt[4].result != None else 0
                programError = 1 if "Error" in tt[5] else 0

                errorFound = 1 if error == 1 or errorFound == 1 else 0
                data[iid][tt[0]] = { "smtcalls" : tt[4].smtcalls,
                                     "timeouted" : tt[4].timeouted,
                                     "result" : tt[4].result,
                                     "icon" : self._mapResultToIcon(tt[4].result),
                                     "time" : "%.2f" % tt[4].time,
                                     "error" : error,
                                     "unique_answer" : 0,
                                     "programError" : programError,
                                     "verified" : tt[4].verified}
                if tt[4].result != None and error == 0:
                    classifications+=[tt[0]]
                    if tt[4].result == 1:
                        answers[0]+=1
                    else:
                        answers[1]+=1

            if len(classifications) == 1 and expectedResult != None and errorFound == 0:
                data[iid][classifications[0]]["unique_answer"] = 1

            if answers[0] == answers[1] and answers[0] > 0:
                data[iid]["ambiguous_answer"] = 1
            else: 
                data[iid]["ambiguous_answer"] = 0


            data[iid]["expected"] = expectedResult
            data[iid]["unique"] = 1 if len(classifications) == 1 and errorFound == 0 else 0
            data[iid]["error"] = errorFound  
            data[iid]["name"] = instanceName                      
            data[iid]["unknown"] = 1 if len(classifications) == 0 else 0

            return webserver.views.jsonview.JSONView (data)
        else:
            return webserver.views.jsonview.JSONView ({"Error" : "Missing parameter"})


    # demo 
    def getUnverifiedSATInstancesForSolver (self,params):
        instances = self._results.getUnverifiedSATInstances (params["solver"])
        return webserver.views.jsonview.JSONView (instances)

    def getAllErrorsForSolver(self,params):
        if "solver" in params:
            solver = params["solver"][0]
            bgroups = list(self._results.getTrackInfo ().keys())

            """
            instances = self._results.getAllUnknownFilesForSolver(solver)
            print("mkdir unknown")
            for i in instances:
                print("cp " + i + " unknown")
            return webserver.views.jsonview.JSONView ([])
            """

            invalidModel = []
            programError = []
            wrongUnsat = []
            unverifiedSat = []
            unknown = []

            for bgroup in bgroups:
                results = self._results.getErrosForSolverGroup(solver,bgroup)
                for (s,g,tname,instance,filepath,t,res,exp,model,verified,output) in results:
                    if verified == False:
                        invalidModel+=[filepath]
                    elif res != exp and res != None:
                        wrongUnsat+=[filepath] #(filepath,"Result: " + str(res), "Expected: " + str(exp))]
                    elif res == None:
                        unknown+=[filepath]
                    elif "Error" in output:
                        #print(t,res)
                        #print(output)
                        if "SIG" in output:
                            test = output.split("died with")

                            import ntpath
                            print(ntpath.basename(filepath),test[len(test)-1])

                            programError+=[filepath]
                    else:
                        pass

                for (s,g,tname,instance,filepath,t,res,exp,model,verified,output) in self._results.getAllUnverifiedSATForSolverGroup(solver,bgroup):
                    unverifiedSat+=[filepath]




                        #raise Exception("This point should never be reached!")
            data = {"invalidModel" : invalidModel,"wrongClassified" : wrongUnsat,"programError" : programError, "unverifiedSat" : unverifiedSat, "unknown" : unknown}

            # hack
            
            print("----------")
            for k in data:
                print("mkdir " + str(k))
                for f in data[k]:
                    print("cp " + f + " ./" + k + "/")
                    #print("rm " + f)
            
            
            #return data
            return webserver.views.jsonview.JSONView (data)

    def quickHack(self,params):
        dataSeq = self.getAllErrorsForSolver({"solver" : ["z3seq"]})
        dataStr = self.getAllErrorsForSolver({"solver" : ["Z3str3-RegEx-fa4a14cd-no-las"]})


        for k in dataStr:
            for filepath in dataStr[k]:
                if filepath not in dataSeq[k]:
                    print(filepath)
                else:
                    pass
                    #print("LOL")

        print("----------")
        print("mkdir invalidModel wrongUnsat programError")
        for k in dataStr:
            for f in dataStr[k]:
                if f not in dataSeq[k]:
                    print("cp " + f + " ./" + k + "/")

        return webserver.views.jsonview.JSONView ("")           


    def getBestSolverForStringOperations(self,params):
        benchmarkInfo = self._results.getTrackInfo ()
        keyWordLimit = 3
        # keywords -> solver -> occurence
        solverStats = dict()
        for g in benchmarkInfo.keys():
            for (tid,tname) in benchmarkInfo[g]:
                print("Track :" + str(tid) + " - " + tname)
                for instanceid in self._results.getInstanceIdsForTrack(tid):
                    #print("Instance id:" + str(instanceid))
                    s = self._results.getBestSolverForInstance(instanceid)
                    if s != None:
                        distributionList = [k[0] for k in sorted(self._track.getStringOperationDataForInstance(instanceid).items(), key = lambda kv:(kv[1], kv[0]))]
                        distributionList.reverse()
                        distributionList = distributionList[:keyWordLimit]
                        distributionList.sort()

                        kt = tuple(distributionList)

                        if kt not in solverStats:
                            solverStats[kt] = dict() 

                        if s not in solverStats[kt]:
                            solverStats[kt][s]=1
                        else:
                            solverStats[kt][s]+=1


        for kt in solverStats:
            print("KeyWords: " + str(kt))
            for s in solverStats[kt]:
                print(s + ": " + str(solverStats[kt][s]))
            print("------")


        return webserver.views.jsonview.JSONView ("")
    
    def getFasterClassifiedInstancesForTrack(self,params):
        if "solvers" in params and "track" in params and len(params["solvers"]) == 2:
            solver1 = params["solvers"][0]
            solver2 = params["solvers"][1]
            #trackid = params["track"][0]
           #bgroup = list(self._results.getTrackInfo ().keys())[0]
            groups = self._results.getTrackInfo ()

            out = ""

            for bgroup in groups: 
                out= "=== "+str(bgroup)+"\n"
                for (trackid,tname) in groups[bgroup]:
                    out+= "==== "+str(tname)+"\n"
                    data = self._results.getArmsHack(trackid) #self._results.get2ComparisonTrackResultsFasterClassified(trackid,solver1,solver2)
                    #out+='''|===\n|Instance |Timeout ''' + str(solver1) + ''' |Timeout ''' + str(solver2) + ''' | Time ''' + str(solver1) + ''' |Time ''' + str(solver2) + '''\n'''
                    out+='''|===\n|Instance |Timeout z3str3-portfolio |Time z3str3-portfolio |Other Solver |Timeout |Time |Deepest Nesting |Block # |Variables #| Symbols # \n'''
                    for iid in data:
                        #(solv,to,error,unk,time) = data[iid][0]
                        solver1Data = data[iid][0]
                        solver2Data = data[iid][1]
                        nesting = 0
                        blocks = 0
                        symbols = ""
                        variables = ""

                        # post processing 
                        for (k,v) in data[iid][2]:
                            if k == "deepest_nest":
                                nesting = v
                            elif k == "(":
                                blocks = v
                            elif k in ["Int","String","Bool"]:
                                variables+=k+" ("+str(v)+"), "
                            else:
                                symbols+=k+" ("+str(v)+"), "


                        #if solver1Data[0] ==  solver1:
                        out+="|{}|{}|{:.2f}|{}|{}|{:.2f}|{}|{}|{}|{}\n".format(self._results.getInstanceNameToId(iid),solver1Data[1],solver1Data[4],solver2Data[0],solver2Data[1],solver2Data[4],nesting,blocks,variables,symbols)

                    out+="|===\n\n"     
                print(out)


            return webserver.views.jsonview.JSONView ("")
        else:
            return webserver.views.jsonview.JSONView ({"Error" : "Missing parameter"})



    def compareSequenceSolverAndArrangement(self,params):
        solver1 = "CVC4"
        solver2 = "Z3str4"

        dataSolver1 = self._results.getResultForSolver(solver1)  #self._results.getResultForSolverGroup(solver1,"RegEx Collected")#Stringfuzz RegEx Transformed")       # 
        dataSolver2 = self._results.getResultForSolver(solver2)  #self._results.getResultForSolverGroup(solver2,"RegEx Collected")#Stringfuzz RegEx Transformed")     # 
        data = dict()

        for t in dataSolver1:
            if t[1] not in data:
                data[t[1]] = {solver1 : None, solver2 : None}
            data[t[1]][solver1] = t[2]

        for t in dataSolver2:
            data[t[1]][solver2] = t[2]

        faster = {str(solver1) : [], str(solver2) : []}
        gap = 15

        folderName = solver1+"_solves-"+solver2+"_not"

        
        print("mkdir "+str(solver1)+"_faster "+str(solver2)+"_faster "+str(solver2)+"_solved_"+str(solver1)+"_unknown "+str(solver1)+"_solved_"+str(solver2)+"_unknown")
        """print("mkdir "+folderName)
        for iid in data.keys():
            if data[iid][solver1].result != None and data[iid][solver2].result == None:
                print("cp " + str(self._results.getFilePath(iid)) + " ./"+folderName+"/")
        """



        #return webserver.views.jsonview.JSONView ("")

        import os

        created_folders = set()
        entered = False
        thisFolder = ""

        for iid in data.keys():
            if data[iid][solver1].result != None and data[iid][solver2].result != None:
                if data[iid][solver1].time + gap <= data[iid][solver2].time:
                    entered = True
                    thisFolder = str(solver1)+"_faster/"
                    faster[solver1]+=[iid]
                elif data[iid][solver1].time  >= data[iid][solver2].time + gap:
                    entered = True
                    thisFolder = str(solver2)+"_faster/"
                    faster[solver2]+=[iid]
            elif data[iid][solver1].result != None:
                faster[solver1]+=[iid]
                thisFolder = str(solver1)+"_solved_"+str(solver2)+"_unknown/"
                entered = True
            elif data[iid][solver2].result != None:
                faster[solver2]+=[iid] 
                thisFolder = str(solver2)+"_solved_"+str(solver1)+"_unknown/"
                entered = True
                

            if entered:
                filepath = self._results.getFilePath(iid)
                fileData = os.path.split(filepath)
                subFolder = thisFolder+(fileData[0][len("/home/mku/wordy/models/"):])

                if subFolder not in created_folders:
                    print("mkdir -p "+subFolder)
                    created_folders.add(subFolder)

                print("cp " + filepath + " ./"+subFolder+"/")

            entered = False



        #print(faster)

        return webserver.views.jsonview.JSONView ("")




    def getSimple (self,params):


       
        res = {}
        groups = self._results.getTrackInfo ()
        s_groups = [g for g in groups if g.endswith("_simple")]
        n_groups = [g for g in groups if not g.endswith("_simple")]
        solver = "Z3str3"
        solver_s = "Z3str3_simple"

        
        for s in [solver,solver+"_simple"]:
            res[s] = {
                'timeouted' : 0,
                'satisfied' : 0,
                'not satisfied' :  0,
                'error': 0,
                'Unknown' : 0,
                'time' : 0.0, #"%.2f" % time,
                'instances' : 0
                }

        for g in s_groups:
            smtcalls,timeouted,satis,unk,nsatis,errors,time,instances = self._results.getSummaryForSolverGroup (solver,g)
            print(self._results.getSummaryForSolverGroup (solver,g))
            res[solver_s]['timeouted']+=timeouted   
            res[solver_s]['satisfied']+=satis
            res[solver_s]['not satisfied']+=nsatis
            res[solver_s]['error']+=errors
            res[solver_s]['Unknown']+=unk
            res[solver_s]['time']+=time
            res[solver_s]['instances']+=instances

        for g in n_groups:
            smtcalls,timeouted,satis,unk,nsatis,errors,time,instances = self._results.getSummaryForSolverGroup (solver,g)
            res[solver]['timeouted']+=timeouted
            res[solver]['satisfied']+=satis
            res[solver]['not satisfied']+=nsatis
            res[solver]['error']+=errors
            res[solver]['Unknown']+=unk
            res[solver]['time']+=time
            res[solver]['instances']+=instances
        
        """

        for g in n_groups:
            s_res = self._results.getResultForSolverGroup(solver,g+"_simple")
            for 
        """

        return webserver.views.jsonview.JSONView (res)












