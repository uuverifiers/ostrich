import sys
import io

class TableGenerator:
    def __init__(self,result,track,solvers =  None,groups = None):
        self._res = result
        self._track  = track
        self._solvers = solvers or self._res.getSolvers ()
        self._groups = groups or [tup[0] for tup in list(self._track.getAllGroups ())]
        
    def genTableHeader (self):
        fstr = "|".join(len(self._solvers)*[("*{{{}}}{{r}}".format (4))])
        
        self._output.write ("\\begin{{tabular}}{{l {} }}\n".format(fstr))
        self._output.write ("\\toprule")
        res = ["\multicolumn{{4}}{{c | }}{{{}}}".format (s) for s in self._solvers]
        self._output.write ("&"+"&".join (res))
        self._output.write ("\\\\ \n")
        res = ["\\faCheck & \\faTimes & \\faQuestion & \\faClockO".format (s) for s in self._solvers]
        self._output.write (" & "+"&".join (res) + " \\\\" )
        for i in range(0,len(self._solvers)):
            self._output.write ("\cmidrule(lr){{{}-{}}}".format (1+i*4,1+(i+1)*4))
    
        
    def getData (self):
        groups = self._groups
        print (groups)
        
        for i,g in enumerate(groups):
            lines = []
            for s in self._solvers:
                res = self._res.getSummaryForSolverGroup (s,g)
                lines.append ("{} & {} &{} & {:.2f}".format(res[2],res[4],res[3],res[6]))
            self._output.write (g)
            self._output.write ("&"+"&".join (lines))
            self._output.write ("\\\\")
            if i % 4 == 3:
                self._output.write ("\hline\n")
            
    def genTableFooter (self):
        self._output.write ("\\end{tabular}")
    
    def generateTable (self,output):
        self._output = output
        self.genTableHeader ()
        self.getData ()
        self.genTableFooter ()
        
if __name__ == "__main__":
    import sys
    import storage.sqlitedb
    db = storage.sqlitedb.DB (sys.argv[1])
    _trackinstance = storage.sqlitedb.TrackInstanceRepository (db)
    _track = storage.sqlitedb.TrackRepository(db,_trackinstance)
    _results = storage.sqlitedb.ResultRepository (db,_track,_trackinstance)
    table  = TableGenerator (_results,_track)
    table.generateTable ()
    
