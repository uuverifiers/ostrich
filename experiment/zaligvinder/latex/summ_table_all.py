import sys
import io

class TableGenerator:
    def __init__(self,result,track,solvers,groups,all_instances):
        self._res = result
        self._track  = track
        self._solvers = solvers or self._res.getSolvers ()
        self._all_instances = all_instances

        #self._solvers = ["Z3str3RE-none","Z3str3RE-li","Z3str3RE-psh","Z3str3RE-ali","Z3str3RE-asi","Z3str3RE-base"]


        self._groups = groups or [tup[0] for tup in list(self._track.getAllGroups ())]

    def _solverNameMap(self,name):
        solvermapping = { "Z3str3RE-base" : "Z3str3RE" , "Z3Trau" : "Z3-Trau", "ostrich" : "OSTRICH", "Z3str3_59e9c87" : "Z3str3", "Z3seq-489" : "Z3Seq"}
        if name in solvermapping:
            return solvermapping[name]
        else:
            return name
        
    def genTableHeader (self):
            layout = "c |"*(len(self._solvers)+1)
            solverLayout = "".join([ "&"+self._solverNameMap(s)  for s in self._solvers])
            self._output.write ("\\resizebox{.95\\textwidth}{!}{\\begin{tabular}{|")
            self._output.write (layout)
            self._output.write ("}\n\\hline\n")
            self._output.write ("" + solverLayout + "\\\\ \n  \\hline\\hline \n")
        
    def getData (self,all=True,group=None):
        output = ["sat ","unsat ","\\hline \n unknown ","timeout ","soundness error ","program crashes ","\\hline \n Total correct ", "Time (s) ", "Time w/o timeouts (s) "]
        key = ["sat","unsat","unk","timeout","errorsTotal","crash","totalClassified","time","timeWO"]
        for s in self._solvers:
            if not all:
                res = self._res.getSummaryForSolverGroupTable(s,group)
            else:
                res = self._res.getSummaryForSolverTable (s)
            res["totalClassified"] = res["sat"]+res["unsat"]-(res["error"]+res["invalid"])
            res["errorsTotal"] = res["error"]+res["invalid"]
            for i in range(0,len(output)):
                output[i]+= "&"+str(res[key[i]])

            #print(f"'{s}' : {res}")

        for l in output:
            self._output.write (l + "\\\\ \n \\hline\n")
            
    def genTableFooter (self):
        self._output.write ("\\end{tabular}}\n\n")
    
    def generateTable (self,output):
        all = self._all_instances
        self._output = output

        self.genLatexDocumentHead()
        if all:
            self.genTableHeader ()
            self.getData ()
            self.genTableFooter ()
        else:
            for g in self._groups:
                self._output.write(g+"\n\n")
                self.genTableHeader ()
                self.getData (all,g)
                self.genTableFooter ()

        self.genLatexDocumentFoot()        
        
    def genLatexDocumentHead(self):
        self._output.write('''\\documentclass[11pt]{article}
\\usepackage{color}
\\usepackage{tikz}
\\usepackage{pgfplots}
\\usepgfplotslibrary{fillbetween}
\\pgfplotsset{compat=1.16}
\\begin{document}
''')

    def genLatexDocumentFoot(self):
        self._output.write('''\\end{document}''')



if __name__ == "__main__":
    import sys
    import storage.sqlitedb
    db = storage.sqlitedb.DB (sys.argv[1])
    _trackinstance = storage.sqlitedb.TrackInstanceRepository (db)
    _track = storage.sqlitedb.TrackRepository(db,_trackinstance)
    _results = storage.sqlitedb.ResultRepository (db,_track,_trackinstance)
    table  = TableGenerator (_results,_track)
    table.generateTable ()
    
"""

 \begin{tabular}{|c | c | c | c|} 
    \hline
     & Solver & Solver & Solver \\ [0.5ex] 
    \hline\hline
    sat &  &  &  \\ 
    \hline
    unsat &  &  &  \\
    \hline
    \hline
    unknow &  &  &  \\
    \hline
    timeout &  &  &  \\
    \hline
    soundness error &  &  &  \\
    \hline
    program error &  &  &  \\
    \hline
    \hline
    Time (s) &  &  &  \\
    \hline
    Time w/o timeouts (s) &  &  &  \\
    \hline
\end{tabular}

"""