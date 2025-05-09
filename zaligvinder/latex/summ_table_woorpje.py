import sys
import io

class TableGenerator:
    def __init__(self,result,track,solvers =  None,groups = None):
        self._res = result
        self._track  = track
        self._solvers = solvers or self._res.getSolvers ()
        self._groups = groups or [tup[0] for tup in list(self._track.getAllGroups ())]
        self._heuristics = [ "VTR", "WLR", "EG", "ELE", "N"]

        ## quick hack
        #self._groupTracks = self._res.getTrackInfo( )

    def _solverNameMap(self,name):
        solvermapping = dict() #{ "cvc4" : "CVC4", "z3str4-overlaps-ds-7" : "Z3hydra-dynamic" , "z3str4-overlaps" : "Z3hydra-static", "z3str3" : "Z3str3", "z3seq" : "Z3Seq"}
        if name in solvermapping:
            return solvermapping[name]
        else:
            return name
    def _mapToIcon(self,name):
        iconmapping = {"time" : "\\faClockO", "classified" : "\\faCheck", "smtcalls" : "\\faCodeFork", "errors" : "\\faBomb" ,"unknown" : "\\faQuestion", "timeouted" : "\\faHourglassEnd"}
        if name in iconmapping:
            return iconmapping[name]
        else:
            return name
    
    def getData (self):
        groups = self._groups
        #print (groups)
        
        totalSumData = dict()

        for i,g in enumerate(groups):
            total_instances = 0
            rdata = dict()
            for s in self._solvers:
                (smtcalls,timeouted,satis,unk,nsatis,errors,time,total,timeWO,totalWO) = self._res.getSummaryForSolverGroupTotalTimeWOTimeout (s,g)
                verified = self._res.getVerifiedCountForSolverGroup(s,g)
                classified = satis + nsatis - errors
                
                # extract solver information
                if s.startswith("woorpje"):
                    tmp = s.split("-")
                    if s.endswith("N"):
                        solverName = tmp[len(tmp)-2]
                        heuristic = "5"
                        parameter = "--"
                    else:
                        solverName = tmp[len(tmp)-3]
                        heuristic = str(self._heuristics.index(tmp[len(tmp)-2]) + 1)
                        parameter = tmp[len(tmp)-1]
                else:
                    solverName = s
                    heuristic = "--"
                    parameter = "--"

                # prepare dicts
                if solverName not in rdata:
                    rdata[solverName] = dict()

                if heuristic not in rdata[solverName]:
                    rdata[solverName][heuristic] = dict()

                if parameter not in rdata[solverName][heuristic]:
                    rdata[solverName][heuristic][parameter] = dict()

                # store data
                rdata[solverName][heuristic][parameter]["classified"] = str(classified)+" ("+str(round((100/total)*classified, 2))+"\\%)"
                #rdata[solverName][heuristic][parameter]["unknown"] = unk
                rdata[solverName][heuristic][parameter]["timeouted"] = str(timeouted)+" ("+str(round((100/total)*timeouted, 2))+"\\%)"
                rdata[solverName][heuristic][parameter]["errors"] = str(errors)+" ("+str(round((100/total)*errors, 2))+"\\%)"
                rdata[solverName][heuristic][parameter]["smtcalls"] = smtcalls if heuristic != "--" else "--"
                rdata[solverName][heuristic][parameter]["time"] = str(round(time, 2))

                self._dataCout = len(list(rdata[solverName][heuristic][parameter].keys()))
                total_instances = total

            ### create table 
            total_colums = 0
            # heuristics and parameters head
            # \multicolumn{2}{l}{Heuristic Number} &    & \multicolumn{3}{c}{\textsc{1}} & & \multicolumn{3}{c}{\textsc{2}}& & \multicolumn{3}{c}{\textsc{3}}& & \multicolumn{3}{c}{\textsc{4}} & &\textsc{5}& &\textsc{--}\\
            # \multicolumn{2}{l}{Parameters} & & 15 & 314 & 1123 & & 2 & 20 & 400 & & 0.15 & 1.075 & 2 & & 0.15 & 1.12358 & 3.14 & & $-$ && $-$\\

            heuristic_head = "\\multicolumn{2}{l}{Heuristic Number} & "
            parameter_head = "\\multicolumn{2}{l}{Parameters} & "
            devide_rule = ""
            solver_rows = dict()
            total_colums+=4

            header_build = False
            for s in rdata.keys():
                solver_rows[s] = dict()
                for h in [ "2", "4", "3", "1", "5", "--"]: #rdata[s].keys():
                    current_parameters = list(rdata[s][h].keys())
                    parameter_count = len(current_parameters)

                    # build header and crule
                    if not header_build:
                        devide_rule+="\\cmidrule(lr){"+str(total_colums)+"-"+str(total_colums+parameter_count)+"}"
                        total_colums+=parameter_count+1
                        if parameter_count > 1:
                            heuristic_head+="& \\multicolumn{"+str(parameter_count)+"}{c}{\\textsc{"+str(h)+"}} & "
                            for p in current_parameters:
                                parameter_head+="& "+str(p)
                            parameter_head+="&"
                        else: 
                            heuristic_head+="& \\textsc{"+str(h)+"} & "
                            parameter_head+="& \\textsc{"+str(current_parameters[0])+"} &"
                    # prepare colums
                    for i,p in enumerate(list(rdata[s][h].keys())):
                        for name in rdata[s][h][p].keys():
                            if name not in solver_rows[s]:
                                solver_rows[s][name]="& " + self._mapToIcon(name) + " & "
                            solver_rows[s][name]+="&" + str(rdata[s][h][p][name]) + " "

                            if i == parameter_count-1:
                                solver_rows[s][name]+="&"
                if not header_build:
                    heuristic_head+="\\\\\n"
                    parameter_head+="\\\\\n"
                    header_build = True
                    print(devide_rule)

            # print table
            self._output.write('\\begin{table*}[t]\n\\centering\n\\resizebox{\\textwidth}{!}{')
            self._output.write('\\begin{tabular}{*{'+str(total_colums)+'}{c}}')
            self._output.write(heuristic_head+"\n"+devide_rule+"\n"+parameter_head+"\n"+devide_rule+"\n")
            for s in solver_rows.keys():
                self._output.write('\\multirow{'+str(self._dataCout)+'}{*}{\\textsc{'+str(s)+'}}')
                for name in solver_rows[s]:
                    self._output.write(solver_rows[s][name]+"\\\\\n")
                self._output.write(devide_rule+"\n")
            self._output.write('\\end{tabular}')
            #   \caption{Summary benchmark data for \textsc{StringFuzzBench} (600 Benchmarks) with extra rule: (\faCheck: correctly classified, \faBomb: incorrectly classified \faCodeFork: calls to the external solver, \faClockO: total time in seconds)} \label{tab:results3_hack}\vspace*{-0.3cm} 
            #self._output.write('}\\caption{Summary benchmark data for \\textsc{'+str(g)+'} ('+str(total_instances)+' Benchmarks): (\\faCheck: correctly classified, \\faQuestion: unknown, \\faHourglassEnd: timeouted instances, \\faBomb: incorrectly classified \\faCodeFork: calls to the external solver, \\faClockO: total time in seconds)}\\label{tab:'+str(g)+'results}\\vspace*{-0.3cm} ')
            self._output.write('}\\caption{Summary benchmark data for \\textsc{'+str(g)+'} ('+str(total_instances)+' Benchmarks): (\\faCheck: correctly classified, \\faHourglassEnd: timeouted instances, \\faBomb: incorrectly classified \\faCodeFork: calls to the external solver, \\faClockO: total time in seconds)}\\label{tab:'+str(g)+'results}\\vspace*{-0.3cm} ')
            self._output.write('\\end{table*}')

    
    def generateTable (self,output):
        self._output = output
        self.getData ()
        
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
