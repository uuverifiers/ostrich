import sys
import io
import statistics
import itertools
import random


class CactusGenerator:
    def __init__(self,result,track,solvers,groups,all_instances):
        self._res = result
        self._track  = track
        self._solvers = solvers or self._res.getSolvers ()
        self._groups = groups or [tup[0] for tup in list(self._track.getAllGroups ())]
        self._maxPoints = 100
        self._startPoints = 0 #45500 # 13500
        self._all_instances = all_instances


        #self._solvers = ["Z3str3RE-none","Z3str3RE-li","Z3str3RE-psh","Z3str3RE-ali","Z3str3RE-asi","Z3str3RE-base"]


    def _solverNameMap(self,name):
        solvermapping = { "Z3str3RE-base" : "Z3str3RE" , "Z3Trau" : "Z3-Trau", "ostrich" : "OSTRICH", "Z3str3_59e9c87" : "Z3str3", "Z3seq-489" : "Z3Seq"}
        if name in solvermapping:
            return solvermapping[name]
        else:
            return name

    def _woorpjeSolvers(self,woorpjePrefix,general_solvers,activeGroup=None):
        woorpje_solvers = self._res.getPureWoorpjeSolvers()
        best_solvers = self._res.getBestWoorpjeSolvers(general_solvers,activeGroup,woorpjePrefix)
        return general_solvers+woorpje_solvers+best_solvers

    def _getLatexColours(self):
        # colour setup
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
        solver_colours = dict()
        for s in self._solvers:
            s = self._solverNameMap(s)
            current_color = next(it_cols)
            solver_colours[s] = """\\definecolor{colour"""+str(s.replace('_','').replace('.',''))+"""}{HTML}{"""+str(current_color[1:])+"""}"""
        return solver_colours
        
    def genTableHeader (self,group):
            if self._all_instances:
                group = "Total"
            #self._output.write ('\\resizebox{.95\\textwidth}{!}{\\pgfplotsset{scaled x ticks=false}\\pgfplotsset{scaled y ticks=false}\\begin{tikzpicture}\\begin{axis}[title='+str(group)+',xmin=-1000,xlabel=Solved instances,ylabel=Time (seconds),,legend columns=2,legend style={nodes={scale=0.5, transform shape}, fill=none,anchor=east,align=center },axis line style={draw=none}, xtick pos=left, ytick pos=left, ymajorgrids=true, legend style={draw=none},x post scale=2,y post scale=1]')
        
            self._output.write ('\\resizebox{.95\\textwidth}{!}{\\pgfplotsset{scaled x ticks=false}\\pgfplotsset{scaled y ticks=false}\\begin{tikzpicture}\\begin{axis}[title='+str(group)+',xlabel=Solved instances,ylabel=Time (seconds),,legend columns=2,legend style={nodes={scale=0.5, transform shape}, fill=none,anchor=east,align=center },axis line style={draw=none}, xtick pos=left, ytick pos=left, ymajorgrids=true, legend style={draw=none},x post scale=2,y post scale=1]') #,xmin=-1000]')
        

            #[xmin=-1000,xlabel=Solved instances,ylabel=Time (seconds),,legend columns=2,legend style={nodes={scale=0.5, transform shape}, fill=none,anchor=east,align=center },axis line style={draw=none}, xtick pos=left, ytick pos=left, ymajorgrids=true, legend style={draw=none},x post scale=2,y post scale=1]

    def getData (self,all_instances):
        groups = self._groups
        #all_instances = False #True # True
        cummulative = True #False # sum up the times
        rdata = {}
        woorpjebest = False
        print (groups)

        # setup solver colours
        for s,c in self._getLatexColours().items():
            self._output.write(c+"\n")

        for i,g in enumerate(groups):
            self.genTableHeader (g)
            fillbetween = []

            if woorpjebest:
                woorpjePrefix = "woorpje-"#-hack-"
                general_solvers = ["cvc4","z3seq","z3str3"]
                if all_instances:
                    self._solvers = self._woorpjeSolvers(woorpjePrefix,general_solvers,None)
                else: 
                    self._solvers = self._woorpjeSolvers(woorpjePrefix,general_solvers,g)

            for solv in self._solvers:
                # Fetch the Data
                l = []
                if all_instances:
                    res = []
                    #res = self._res.getResultForSolverNoUnk(solv)
                    for g in groups:
                       res+=self._res.getResultForSolverGroupNoUnk(solv,g) 

                    ### sort
                    res.sort(key = lambda r: r[2].time)
                else:
                    res = self._res.getResultForSolverGroupNoUnk(solv,g)
                s = 0
                for i,data in enumerate(res):
                    if cummulative:
                        s = s+data[2].time
                        l.append ({"x" : i,
                               "instance" : data[1],
                               "time" : data[2].time,
                               "y" : s})
                    else:
                        s = data[2].time 
                        l.append ({"x" : i,
                               "instance" : data[1],
                               "time" : data[2].time,
                               "y" : s})
            


                solv = self._solverNameMap(solv)

                # accumulate points
                if len(l) < self._maxPoints:
                    ll = [(i["x"],i["y"]) for i in l]
                else:
                    ll = []
                    total_points = len(l)

                    accumulation_count = round((total_points-self._startPoints)/(self._maxPoints-2))
                    i = self._startPoints+1
                    j = 1
                    ll.append((self._startPoints+1,l[self._startPoints]["y"]))
                    while True:
                        if j*accumulation_count+1 < (total_points-self._startPoints):
                            x = statistics.mean([value["x"] for value in l[i:self._startPoints+(accumulation_count*j+1)]])
                            y = statistics.mean([value["y"] for value in l[i:self._startPoints+(accumulation_count*j+1)]])
                            ll.append((x,y))
                            i=accumulation_count+i 
                        else: 
                            if i < ((total_points-self._startPoints)-1):

                                x = statistics.mean([value["x"] for value in l[i:total_points-1]])
                                y = statistics.mean([value["y"] for value in l[i:total_points-1]])
                                ll.append((x,y))
                            break
                        j+=1
                    ll.append((total_points,l[total_points-1]["y"]))

                # cactus points
                output = ('\n\\addplot[name path=path'+str(solv.replace('_','').replace('.',''))+' , colour'+str(solv.replace('_','').replace('.',''))+', line width=1.5pt] coordinates {')

                #output = ('\\addplot[color='+str(colors[solverNo-1])+',mark=x] coordinates {')
                for (x,y) in ll:
                    output+="("+str(x)+","+str(y/1000)+")"
                output+= '};\n'

                # collect data to fill between curve and x axis; needs to be placed in the end 
                # Needs Packages:
                # \usepackage{pgfplots}
                # \usepgfplotslibrary{fillbetween}
                fillbetween+=['\\path[name path=axis'+str(solv.replace('_','').replace('.',''))+'] (axis cs:0,0) -- (axis cs:'+str(ll[len(ll)-1][0])+',0);\n']
                fillbetween+=['\\addplot [thick,color=colour'+str(solv.replace('_','').replace('.',''))+',fill=colour'+str(solv.replace('_','').replace('.',''))+',fill opacity=0.1] fill between [of=path'+str(solv.replace('_','').replace('.',''))+' and axis'+str(solv.replace('_','').replace('.',''))+'];\n']


                output+='\\addlegendentry{'+str(solv)+'}\n'
                output+='\n'
                self._output.write (output)

            for l in fillbetween:
                self._output.write (l)

            self.genTableFooter ()

            if all_instances:
                break
            
    def genTableFooter (self):
        self._output.write ('\\end{axis}\\end{tikzpicture}}\n\n')
    
    def generateTable (self,output):
        self._output = output
        self.genLatexDocumentHead()
        self.getData (self._all_instances)
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
    for i in cactusPoints:
        print('\\resizebox{.2\\textwidth}{!}{\\begin{tikzpicture}\\begin{axis}[title=Track '+str(int_to_Roman(i))+',xlabel=Solved instances,ylabel=Time (seconds),legend style={at={(0.02,0.98)},anchor=north west}]')

        solverNames = ["woorpje","cvc4","z3str3","z3seq","norn","sloth"]
        #if i == 5:
        #    solvers = ["WoorpjeSAT","z3str3Solver","z3sequenceSolver","Norn"]

        for t in solverNames: # ,"CVC4"ec
            solverNo+=1
            output = ('\\addplot coordinates {')

            #output = ('\\addplot[color='+str(colors[solverNo-1])+',mark=x] coordinates {')
            for (solved,time) in cactusPoints[i][t]:
                if time < maxTimes[i-1]:
                    output+="("+str(solved)+","+str(time)+")"
            #output=output[:-1]
            output+= '};'
            print(output)
            print('\\addlegendentry{'+str(t)+'}')
            print('\n')
        solverNo=0
        print('\end{axis}\end{tikzpicture}}')
"""