import sys
import io
import random
import itertools

class TableGenerator:
    def __init__(self,result,track,solvers =  None,groups = None):
        self._res = result
        self._track  = track
        self._solvers = solvers or self._res.getSolvers ()
        self._groups = groups or [tup[0] for tup in list(self._track.getAllGroups ())]


        ## create solver colour map
        colors = ["#25333D","#0065AB","#8939AD","#007E7A","#CD3517","#318700","#80746D","#FF9A69","#00D4B8","#85C81A", #none_5_z3str3
          "#AC75C6","#0F1E82","#A3EDF6","#FFB38F","#49AFD9",]

        # extend the colors 
        r = lambda: random.randint(0,255)
        colorGen = lambda : '#%02X%02X%02X' % (r(),r(),r())
        while len(colors) < 26:
          newColor = colorGen()
          if newColor not in colors:
            colors+=[newColor]

        it_cols = itertools.cycle(colors)

        self._solverColour = dict()

        for s in self._solvers:
            self._solverColour[s] = next(it_cols)

        ## quick hack
        #self._groupTracks = self._res.getTrackInfo( )

    def _solverNameMap(self,name):
        return '+++<span style="color:'+str(self._solverColour[name])+';font-weight: bold;">'+str(name)+'</span>+++'

        #solvermapping = dict() #{ "cvc4" : "CVC4", "z3str4-overlaps-ds-7" : "Z3hydra-dynamic" , "z3str4-overlaps" : "Z3hydra-static", "z3str3" : "Z3str3", "z3seq" : "Z3Seq"}
        #if name in solvermapping:
        #    return solvermapping[name]
        #else:
        #    return name


    ### PAR 2 Score
    # The solvers will ranked using the PAR-2 scheme: The score of a solver is defined as the sum of all runtimes for solved instances + 2*timeout for unsolved instances, lowest score wins.
    def _calculatePar2Score(self,solvedTime,failedCount,errorCount,timeout=20):
        return solvedTime+(failedCount*(timeout*2))+(errorCount*(timeout*5))



    #### SORT DATA BY PAR2SCORE sorted(totalSumData.items(), key=lambda x: x[13], reverse=True)

    def getData (self,):
        show_ideal_solver = False # True
        ideal_solver_of = ["z3str4-arrangement","z3str4-lenabs","z3str4-seq"]
        groups = self._groups
        #print (groups)
        
        totalSumData = dict()
        totalIdealData = [0,0,0,0,0,0,0,0.0,0.0,0.0,0,0,0]


        for i,g in enumerate(groups):
            best = dict()

            total_instances = 0

            self._output.write ("=== "+g+"\n")
            lines = []
        
            for s in self._solvers:
                if s not in totalSumData:
                    totalSumData[s] = [0]*13

                data = self._res.getSummaryForSolverGroupXP (s,g)

                classified = data["sat"] + data["unsat"] - data["errors"]
                total_instances = data["total"]
                par2score = self._calculatePar2Score(data["totalSolvedTime"],total_instances-classified,data["errors"])

                lines.append ("|{}|{} ({})|{}|{}|{}|{}|{}|{}|{:.2f}|{}|{}|{:.2f}|{:.2f}\n".format(self._solverNameMap(s),classified,round(classified/data["time"],2),data["sat"],data["unsat"],data["unknown"],data["errors"],data["crashes"],data["timeouted"],par2score,data["total"],data["totalWO"],data["time"],data["timeWO"]))

                #correctly,satis,nsatis,unk,errors,timeouted,total,time,totalWO,timeWO
                
                totalSumData[s][0]+=classified
                totalSumData[s][1]+=data["sat"]
                totalSumData[s][2]+=data["unsat"]
                totalSumData[s][3]+=data["unknown"]
                totalSumData[s][4]+=data["errors"]
                totalSumData[s][5]+=data["timeouted"]
                totalSumData[s][6]+=data["total"]
                totalSumData[s][7]+=data["time"]
                totalSumData[s][8]+=data["totalWO"]
                totalSumData[s][9]+=data["timeWO"]
                totalSumData[s][10]+=data["verified"]
                totalSumData[s][11]+=data["crashes"]     
                totalSumData[s][12]+=par2score

                #best[s] = [classified,data["time"],data["timeWO"]]
                best[s] = par2score


            """
            if show_ideal_solver:
                l = []
                s = 0
                result = self._res.getIdealSolverResultsForGroup(g,ideal_solver_of)

                print(len(result))
                Isatis = 0
                Insatis = 0
                Itime = 0
                for i,t in enumerate(result):
                    Itime = Itime+t[2]
                    if t[1] == True:
                        Isatis+=1
                    elif t[1] == False:
                        Insatis+=1


                lines.append ("|{}|{}|{}|{}|{}|{}|{}|{}|{}|{:.2f}|{}|{:.2f}\n".format("Ideal",Insatis+Isatis,Isatis,Insatis,total_instances-(Insatis+Isatis),0,0,0,total_instances,Itime,Insatis+Isatis,Itime))
                totalIdealData[0]+=Insatis+Isatis
                totalIdealData[1]+=Isatis
                totalIdealData[2]+=Insatis
                totalIdealData[3]+=total_instances-(Insatis+Isatis)
                totalIdealData[6]+=total_instances
                totalIdealData[7]+=Itime
                totalIdealData[8]+=Insatis+Isatis
                totalIdealData[9]+=Itime
            """

            self._output.write ('''\n\n[.text-center]
image::img/'''+g.lower().replace(" ", "")+'''.png[cactus]\n\n''')

            #self._output.write ('''\n\n[.text-center]
            #image::img/keys/'''+g.lower().replace(" ", "")+'''.png[keywords]\n\n''')
            #self._output.write ('''|===\n|Tool name |Correctly classified  |Declared satisfiable (Veriefied correctly) |Declared unsatisfiable |Declared unknown |Error |Timeout |Total instances |Total time|Total instances w/o TO |Total time w/o TO\n''')
            self._output.write ('''|===\n|Tool name |Correctly classified (Time ratio) |Declared satisfiable |Declared unsatisfiable |Declared unknown |Error |Crashes |Timeout |Par2Score |Total instances |Total instances w/o TO | Total time |Total time w/o TO\n''')
            self._output.write ("".join (lines))
            self._output.write ("|===\n\n")

            # Best solver of the group
            current = []
            for s in best:
                if len(current) == 0:
                    current = [best[s],s]
                elif current[0] >= best[s]:
                    current = [best[s],s]

                #elif current[0]/current[1] <= best[s][0]/best[s][1]:
                #    current = best[s]+[s]
            """
            self._output.write('''[NOTE]
====
Best solver of this benchmark set '''+str(self._solverNameMap(current[3]))+''' classified '''+str(current[0])+''' instances in '''+str(current[1])+'''s.
==== \n\n''')
            """
            self._output.write('''[NOTE]
====
Best solver of this benchmark set '''+str(self._solverNameMap(current[1]))+''' got a PAR2 score of '''+str(current[0])+'''.
==== \n\n''')


        # overview Data
        lines = []
        self._output.write("\n\n=== Total\n")

        """
        if show_ideal_solver:
            totalSumData["ideal_solver"] = totalIdealData
        """

        for s in totalSumData:
            (correctly,satis,nsatis,unk,errors,timeouted,total,time,totalWO,timeWO,verified,crashes,par2score) = totalSumData[s]
            lines.append ("|{}|{} ({})|{}|{}|{}|{}|{}|{}|{:.2f}|{}|{}|{:.2f}|{:.2f}\n".format(self._solverNameMap(s),correctly,round(classified/time,2),satis,nsatis,unk,errors,crashes,timeouted,par2score,total,totalWO,time,timeWO))
        

        self._output.write ('''\n\n[.text-center]
image::img/total.png[cactus]\n\n''')

        self._output.write ('''|===\n|Tool name |Correctly classified (Time ratio) |Declared satisfiable |Declared unsatisfiable |Declared unknown |Error |Crashes |Timeout |Par2Score |Total instances |Total instances w/o TO | Total time |Total time w/o TO\n''')
        self._output.write ("".join (lines))
        self._output.write ("|===\n\n")

        # Best solver of the group
        current = []
        for s in totalSumData:
            if len(current) == 0:
                current = [totalSumData[s][12],s]
            elif current[0] >= totalSumData[s][12]:
                current = [totalSumData[s][12],s]

        self._output.write('''[NOTE]
====
Best solver of this run '''+str(self._solverNameMap(current[1]))+''' got a PAR2 score of '''+str(current[0])+'''.
==== \n\n''')



    def getDataTrack (self,):
        groups = self._groups        
        totalSumData = dict()
        self._groupTracks = self._res.getTrackInfo( )

        for i,g in enumerate(groups):
            for (tid,tname) in self._groupTracks[g]:
                lines = []
                best = dict()
                total_instances = 0
                self._output.write ("=== "+g+"\n")
                for s in self._solvers:
                    if s not in totalSumData:
                        totalSumData[s] = [0]*13
                    data = self._res.getSummaryForSolverTrackXP (s,tid)

                    classified = data["sat"] + data["unsat"] - data["errors"]
                    total_instances = data["total"]
                    par2score = self._calculatePar2Score(data["totalSolvedTime"],total_instances-classified,data["errors"])

                    lines.append ("|{}|{} ({})|{}|{}|{}|{}|{}|{}|{:.2f}|{}|{}|{:.2f}|{:.2f}\n".format(self._solverNameMap(s),classified,round(classified/data["time"],2),data["sat"],data["unsat"],data["unknown"],data["errors"],data["crashes"],data["timeouted"],par2score,data["total"],data["totalWO"],data["time"],data["timeWO"]))

                    totalSumData[s][0]+=classified
                    totalSumData[s][1]+=data["sat"]
                    totalSumData[s][2]+=data["unsat"]
                    totalSumData[s][3]+=data["unknown"]
                    totalSumData[s][4]+=data["errors"]
                    totalSumData[s][5]+=data["timeouted"]
                    totalSumData[s][6]+=data["total"]
                    totalSumData[s][7]+=data["time"]
                    totalSumData[s][8]+=data["totalWO"]
                    totalSumData[s][9]+=data["timeWO"]
                    totalSumData[s][10]+=data["verified"]
                    totalSumData[s][11]+=data["crashes"]     
                    totalSumData[s][12]+=par2score
                    best[s] = par2score

                self._output.write ('''\n\n[.text-center]
image::img/'''+g.lower().replace(" ", "")+'''.png[cactus]\n\n''')

                self._output.write ('''|===\n|Tool name |Correctly classified (Time ratio) |Declared satisfiable |Declared unsatisfiable |Declared unknown |Error |Crashes |Timeout |Par2Score |Total instances |Total instances w/o TO | Total time |Total time w/o TO\n''')
                self._output.write ("".join (lines))
                self._output.write ("|===\n\n")

                # Best solver of the track
                current = []
                for s in best:
                    if len(current) == 0:
                        current = [best[s],s]
                    elif current[0] >= best[s]:
                        current = [best[s],s]

                self._output.write('''[NOTE]
====
Best solver of this benchmark set '''+str(self._solverNameMap(current[1]))+''' got a PAR2 score of '''+str(current[0])+'''.
==== \n\n''')


            # overview Data
            lines = []
            self._output.write("\n\n=== Total\n")

            for s in totalSumData:
                (correctly,satis,nsatis,unk,errors,timeouted,total,time,totalWO,timeWO,verified,crashes,par2score) = totalSumData[s]
                lines.append ("|{}|{} ({})|{}|{}|{}|{}|{}|{}|{:.2f}|{}|{}|{:.2f}|{:.2f}\n".format(self._solverNameMap(s),correctly,round(classified/time,2),satis,nsatis,unk,errors,crashes,timeouted,par2score,total,totalWO,time,timeWO))
            

            self._output.write ('''\n\n[.text-center]
    image::img/total.png[cactus]\n\n''')

            self._output.write ('''|===\n|Tool name |Correctly classified (Time ratio) |Declared satisfiable |Declared unsatisfiable |Declared unknown |Error |Crashes |Timeout |Par2Score |Total instances |Total instances w/o TO | Total time |Total time w/o TO\n''')
            self._output.write ("".join (lines))
            self._output.write ("|===\n\n")

            # Best solver of the group
            current = []
            for s in totalSumData:
                if len(current) == 0:
                    current = [totalSumData[s][12],s]
                elif current[0] >= totalSumData[s][12]:
                    current = [totalSumData[s][12],s]

            self._output.write('''[NOTE]
    ====
    Best solver of this set '''+str(self._solverNameMap(current[1]))+''' got a PAR2 score of '''+str(current[0])+'''.
    ==== \n\n''')


    def getDataX (self):
        groups = self._groups
        self._groupTracks = self._res.getTrackInfo( )
        #print (groups)
        
        totalSumData = dict()

        for i,g in enumerate(groups):
            self._output.write ("=== "+g+"\n")
            for (tid,tname) in self._groupTracks[g]:
                best = dict()
                lines = []
                self._output.write ("==== "+tname+"\n")
        
                for s in self._solvers:
                    if s not in totalSumData:
                        totalSumData[s] = [0,0,0]

                    (smtcalls,timeouted,satis,unk,nsatis,errors,time,total,timeWO,totalWO) = self._res.getSummaryForSolverTrackTotalTimeWOTimeout (s,tid)
                    lines.append ("|{}|{}|{}|{}|{}|{}|{}|{}|{}|{:.2f}|{:.2f}\n".format(self._solverNameMap(s),satis,nsatis,unk,errors,timeouted,total,totalWO,time,timeWO))


                    classified = satis + nsatis -errors
                    totalSumData[s][0]+=classified
                    totalSumData[s][1]+=time
                    totalSumData[s][2]+=timeWO
                    best[s] = [classified,time,timeWO]

            #self._output.write ("=== "+g+"\n")

                self._output.write ('''\n\n[.text-center]
image::img/'''+g.lower().replace(" ", "")+'''/'''+tname.lower().replace(" ", "")+'''.png[cactus]\n\n''')

                self._output.write ('''|===\n|Tool name |Declared satisfiable |Declared unsatisfiable |Declared unknown |Error |Timeout |Total instances |Total time|Total instances w/o TO |Total time w/o TO\n''')
                self._output.write ("".join (lines))
                self._output.write ("|===\n\n")

                # Instances Details for track
                instances = self._res.getInstanceIdsForTrack(tid)
                instanceData = dict()
                keywords = ["Int","String"]

                for iid in instances:
                    newInstanceData = self._res.instanceInformation(iid)
                    for k in newInstanceData:
                        if k not in instanceData:
                            instanceData[k] = 0
                        instanceData[k]+=newInstanceData[k]

                average_length = int(instanceData["length"] / len(instances))
                total_variables = sum([instanceData[k] for k in keywords])
                variable_data = dict()
                for k in keywords:
                    variable_data[k] = (instanceData[k],instanceData[k]/total_variables)

                self._output.write ('''|===\n|Average length |Total variables |Average variables |Total Int variables | Int variable ratio |Total string variables |String variable ratio\n''')
                self._output.write ("|{}|{}|{:.2f}|{}|{:.2f}|{}|{:.2f}\n".format(average_length,total_variables,total_variables/len(instances),variable_data["Int"][0],variable_data["Int"][1],variable_data["String"][0],variable_data["String"][1]))
                self._output.write ("|===\n\n")

                # Best solver of the track
                current = []
                for s in best:
                    if len(current) == 0:
                        current = best[s]+[s]
                    elif current[0]/current[1] <= best[s][0]/best[s][1]:
                        current = best[s]+[s]

                self._output.write('''[NOTE]
====
Best solver of this track '''+str(current[3])+''' classified '''+str(current[0])+''' instances in '''+str(current[1])+'''s.
==== \n\n''')


        # overview Data
        lines = []
        self._output.write("\n\n=== Total\n")

        for s in totalSumData:
            lines.append ("|{}|{}|{:.2f}|{:.2f}\n".format(s,totalSumData[s][0],totalSumData[s][1],totalSumData[s][2]))

        self._output.write ('''|===\n|Tool name |Correctly classified (Time Ratio) |Total time| Total time w/o TO\n''')
        self._output.write ("".join (lines))
        self._output.write ("|===\n\n")

    
    def generateTable (self,output):
        self._output = output
        self.getData() #Track () #getData ()

    def generateTableTrack (self,output):
        self._output = output
        self.getDataTrack ()
        
if __name__ == "__main__":
    import sys
    import storage.sqlitedb
    db = storage.sqlitedb.DB (sys.argv[1])
    _trackinstance = storage.sqlitedb.TrackInstanceRepository (db)
    _track = storage.sqlitedb.TrackRepository(db,_trackinstance)
    _results = storage.sqlitedb.ResultRepository (db,_track,_trackinstance)
    table  = TableGenerator (_results,_track)
    table.generateTable ()
    



'''
|===
|Program |Satis | NSatis | Error | Unknown | Timeout | Total | Time | TimeWO
|woorpje|200|0|0|0|0|200|8.10|8.10
|cvc4|182|0|0|0|18|200|543.32|3.32
|z3str3|197|0|0|1|2|200|105.07|45.07
|z3seq|183|0|0|0|17|200|545.24|35.24
|norn|176|4|4|0|20|200|1037.63|437.63
|sloth|101|0|0|0|99|200|3658.34|688.34
|===
'''


'''
<link rel="stylesheet" type="text/css" href="ascii.css">
<link rel="stylesheet" type="text/css" href="css.css">
'''
