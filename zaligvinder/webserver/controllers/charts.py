import webserver.views.jsonview
import webserver.views.PNGView
import webserver.views.TextView
import webserver.views.ZIPView




class ChartController:
    def __init__(self,result,track):
        self._result = result
        self._track = track

    def _solverNameMap(self,name):
        solvermapping = { "cvc4" : "CVC4", "z3str4-ds" : "Dynamic Difficulty Estimation" , "z3str4-no-ds" : "Static Difficulty Estimation", "z3str3" : "Z3str3", "z3str4" : "Z3str4", "z3seq" : "Z3seq"}
        if name in solvermapping:
            return solvermapping[name]
        if name.startswith("woorpje-hack"):
            return "w-hack"+name[len("woorpje-hack"):]
        else:
            return name

    def _woorpjeSolvers(self,woorpjePrefix,general_solvers,activeGroup=None):
        woorpje_solvers = self._result.getPureWoorpjeSolvers()
        best_solvers = self._result.getBestWoorpjeSolvers(general_solvers,activeGroup,woorpjePrefix)
        return general_solvers+woorpje_solvers+best_solvers

    def generateCactus(self,params,to_zip=None,all_instances=False,cummulative=True):
        no_unk = False
        ideal_solver = False # True
        ideal_solver_of = ["z3str4-arrangement","z3str4-lenabs","z3str4-seq"]

        # WRITE A FUNCTION FOR THIS!
        #solvermapping = { "cvc4" : "CVC4", "z3str4-overlaps-ds-7" : "Z3hydra-dynamic" , "z3str4-overlaps-murphy" : "Z3hydra-static"}


        if no_unk:
            results_for_solver_func=self._result.getResultForSolverGroup
            results_for_solver_track_func=self._result.getResultForSolverTrack
        else:
            results_for_solver_func=self._result.getResultForSolverGroupNoUnk
            results_for_solver_track_func=self._result.getResultForSolverTrackNoUnk


        rdata = {}
        avtracks = self._result.getTrackIds()
        activeGroup = list( self._result.getTrackInfo().keys() )[0]
        activeTrack = None
        start_at = 0

        # fetch solvers
        if "solver" in params:
            solvers = params["solver"]
        else:
            solvers = self._result.getSolvers ()

        # set group
        if "bgroup" in params:
            activeGroup = params["bgroup"][0]

        if "all" in params:
            all_instances = True

        # do not sum up in cacuts
        if "single" in params:
            cummulative = False

        if "start" in params:
            start_at = int(params["start"][0])

        if "woorpjebest" in params:
            woorpjePrefix = "woorpje-"
            general_solvers = ["cvc4","z3seq","z3str3"]
            if all_instances:
                solvers = self._woorpjeSolvers(woorpjePrefix,general_solvers,None)
            else: 
                solvers = self._woorpjeSolvers(woorpjePrefix,general_solvers,activeGroup)


        if ideal_solver and not no_unk:
            l = []
            s = 0
            result = []
            if all_instances:
                for g in list(self._result.getTrackInfo().keys()):
                    result+=self._result.getIdealSolverResultsForGroup(g,ideal_solver_of)
                result.sort(key=lambda t: t[2])
            else:
                result = self._result.getIdealSolverResultsForGroup(activeGroup,ideal_solver_of)

                print(len(result))


            for i,t in enumerate(result):
                s = s+t[2]
                l.append ({"x" : i,
                           "instance" : t[1],
                           "time" : t[2],
                           "y" : s
                })

            rdata["ideal"] = l



        for solv in solvers:
            l = []
            if all_instances:
                if not no_unk:
                    res = self._result.getResultForSolverNoUnk(solv)
                else:
                    res = self._result.getResultForSolver(solv)
            else:
                if "track" not in params or int(str(params["track"][0])) not in avtracks:
                    res = results_for_solver_func(solv,activeGroup)
                else:
                    track = int(str(params["track"][0]))
                    activeTrack = [ttracks[1] for ttracks in self._result.getTrackNames() if ttracks[0] == track][0]
                    res = results_for_solver_track_func(solv,track)

            s = 0
            for i,data in enumerate(res):
                if cummulative:
                    s = s+data[2].time
                else:
                    s = data[2].time 

                l.append ({"x" : i,
                              "instance" : data[1],
                              "time" : data[2].time,
                              "y" : s
                              })
            rdata[solv] = l

        if "format" not in params:
            return webserver.views.jsonview.JSONView (rdata)
        else:
            form = params["format"][0]
            if form == "png":
                from matplotlib.figure import Figure
                from matplotlib.font_manager import FontProperties
                from io import BytesIO
                import itertools
                import random


                # colour setup
                colors = ["#25333D","#0065AB","#8939AD","#007E7A","#CD3517","#318700","#80746D","#FF9A69","#00D4B8","#85C81A", #none_5_z3str3
                  "#AC75C6","#0F1E82","#A3EDF6","#FFB38F","#49AFD9",]


                # 4 color setup
                #colors = ["#364f6b","#3fc1c9","#ffb6b9","#fc5185"]

                # berkley colours
                #colors = ["#c5820e","#003262","#3b7ea1","#feb516"]


                # extend the colors 
                r = lambda: random.randint(0,255)
                colorGen = lambda : '#%02X%02X%02X' % (r(),r(),r())
                while len(colors) < 26:
                  newColor = colorGen()
                  if newColor not in colors:
                    colors+=[newColor]



                it_cols = itertools.cycle(colors)

                fig = Figure(figsize=(6,3))
                ax = fig.subplots()

                fontP = FontProperties()
                fontP.set_size('small')

                for p in rdata.keys():
                    current_color = next(it_cols)
                    data = [i["y"] for i in rdata[p] if i["x"] >= start_at]
                    ax.plot (range(start_at,len(data)+start_at),data,'-',linewidth=2.5,label=self._solverNameMap(p),color=current_color)#,marker='.')
                    ax.fill_between(range(start_at,len(data)+start_at),data, color=current_color,alpha=0.15)
                    lgd = ax.legend(fancybox=True,bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left', ncol=2, mode="expand", borderaxespad=0.,frameon=False,prop={'size': 6})#loc='upper left', bbox_to_anchor=(0, 0, 0, 0))#bbox_to_anchor=(0.4, 1.1))
                    ax.spines['top'].set_visible(False)
                    ax.spines['right'].set_visible(False)
                    ax.spines['bottom'].set_visible(False)
                    ax.spines['left'].set_visible(False)
                    ax.yaxis.grid(color='black', linestyle='dashdot', linewidth=0.1)
                    # Save it to a temporary buffer.
                    buf = BytesIO()
                if to_zip != None:
                    if activeTrack != None:
                        name = activeTrack
                    else:
                        name = activeGroup
                    fileName = name.lower().replace(" ", "")+'.png'
                    #fig.savefig(to_zip+"/"+fileName,format="png",dpi=160,prop=fontP,bbox_extra_artists=(lgd,), bbox_inches='tight')
                    fig.savefig(to_zip+"/"+fileName,format="png",dpi=320,prop=fontP,bbox_extra_artists=(lgd,), bbox_inches='tight')
                    return to_zip+"/"+fileName 
                else:
                    #fig.savefig(buf, format="png",dpi=160,prop=fontP,bbox_extra_artists=(lgd,), bbox_inches='tight')
                    fig.savefig(buf, format="png",dpi=320,prop=fontP,bbox_extra_artists=(lgd,), bbox_inches='tight')
                    return webserver.views.PNGView.PNGView (buf)
            else:
                return webserver.views.TextView.ErrorText ("Unknown format")

    def downloadGraphTrack(self,params,apply_fun):
        import tempfile
        import zipfile
        import shutil
        tmpFolder = tempfile.mkdtemp()
        fileList = []
        cummulative = True


        if "all" in params:
            all_instances = True
            groups = ["total"]
        else:
            all_instances = False
            groups = list( self._result.getTrackInfo().keys() )

        if "solver" in params:
            solvers = params["solver"]
        else:
            solvers = self._result.getSolvers ()

        if "woorpjebest" in params:
            woorpjePrefix = "woorpje-"
            general_solvers = ["cvc4","z3seq","z3str3"]
            solvers = self._woorpjeSolvers(woorpjePrefix,general_solvers,None)

        # do not sum up in cacuts
        if "single" in params:
            cummulative = False

        for g in groups:
            fileList.append(apply_fun({"format":["png"],"bgroup":[g], "solver":solvers},tmpFolder,all_instances,cummulative))

        """
        with zipfile.ZipFile('out.zip', 'w') as zipMe:        
            for file in fileList:
                zipMe.write(file, compress_type=zipfile.ZIP_DEFLATED)
        """
        #shutil.rmtree(tmpFolder)

        return webserver.views.TextView.ErrorText ("Images stored in " + tmpFolder)

    def downloadGraphGroup(self,params,apply_fun):
        import tempfile
        import shutil
        import os 
        tmpFolder = tempfile.mkdtemp()
        fileList = []

        trackInfo = self._result.getTrackInfo()
        for g in trackInfo:
            os.mkdir(tmpFolder+"/"+g.lower().replace(" ", ""))
            for (tid,tname) in trackInfo[g]:
                fileList.append(apply_fun({"format":["png"],"track":[tid]},tmpFolder+"/"+g.lower().replace(" ", "")))

        return webserver.views.TextView.ErrorText ("Images stored in " + tmpFolder)


    def downloadCactus(self,params):
        return self.downloadGraphTrack(params,self.generateCactus)

    def downloadCactusTracks(self,params):
        return self.downloadGraphTrack(params,self.generateCactus)

    def downloadStringOperationDistribution(self,params):
        return self.downloadGraphTrack(params,self.generateStringOperationDistribution)

    def downloadStringOperationDistributionTracks(self,params):
        return self.downloadGraphTrack(params,self.generateStringOperationDistribution)
        
    def generateStringOperationDistribution(self,params,to_zip=None,all_instances=None):
        avtracks = self._result.getTrackIds()
        activeGroup = list( self._result.getTrackInfo().keys() )[0]
        activeTrack = None
        track = 0

        if "bgroup" in params:
            activeGroup = params["bgroup"][0]
        if "track" in params and int(str(params["track"][0])) in avtracks:
            track = int(str(params["track"][0]))

        if activeTrack == None:
            data = self._track.getStringOperationDataForGroup(activeGroup)
        else:
            data = self._track.getStringOperationDataForTrack(params["track"][0])
            activeTrack = [ttracks[1] for ttracks in self._result.getTrackNames() if ttracks[0] == track][0]

        if "format" not in params:
            return webserver.views.jsonview.JSONView (data)
        else:
            form = params["format"][0]
            if form == "png":
                from matplotlib.figure import Figure
                from matplotlib.font_manager import FontProperties
                from io import BytesIO
                import itertools
                import random
                import numpy as np

                # remove empty entries
                oldDataKeys = list(data.keys()).copy()
                newKeys = []
                for k in oldDataKeys:
                    if data[k] == 0:
                        del data[k]
                    else:
                        newKeys+=[k]

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

                fig = Figure(figsize=(6,3))
                ax = fig.subplots()

                fontP = FontProperties()
                fontP.set_size('small')

                index = np.arange(len(list(data.keys())))
                bar_width = 0.95
                opacity = 1

                c = 0
                for k, v in sorted(data.items(), key=lambda item: item[1]):
                    current_color = next(it_cols)
                    ax.barh(c*bar_width+c*(1-bar_width), int(v), bar_width,
                                     alpha=opacity,
                                     label=k,
                                     color=current_color)
                    ax.text(v + 3, c*bar_width+c*(1-bar_width)-0.125, str(v), color=current_color, fontweight='bold')
                    c+=1

                #lgd = ax.legend(fancybox=True,bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left', ncol=2, mode="expand", borderaxespad=0.,frameon=False)#loc='upper left', bbox_to_anchor=(0, 0, 0, 0))#bbox_to_anchor=(0.4, 1.1))
                ax.spines['top'].set_visible(False)
                ax.spines['right'].set_visible(False)
                ax.spines['bottom'].set_visible(False)
                ax.spines['left'].set_visible(False)
                ax.xaxis.grid(color='black', linestyle='dashdot', linewidth=0.1)
                ax.set_yticks(index)
                ax.set_yticklabels(newKeys)

                buf = BytesIO()

                if to_zip != None:
                    if activeTrack != None:
                        name = activeTrack
                    else:
                        name = activeGroup
                    fileName = name.lower().replace(" ", "")+'.png'
                    fig.savefig(to_zip+"/"+fileName,format="png",dpi=160,prop=fontP,bbox_inches='tight')
                    return to_zip+"/"+fileName 
                else:
                    fig.savefig(buf, format="png",dpi=160,prop=fontP, bbox_inches='tight')
                    return webserver.views.PNGView.PNGView (buf)
            else:
                return webserver.views.TextView.ErrorText ("Unknown format")

        
    
    def generateTrackDistribution (self,params):
        rdata = {}

        group = params["bgroup"][0]
        
        if not isinstance(params["track"],list):
            track = int(params["track"])
        else:
            track = int(params["track"][0])


        if "solver" in params:
            solvers = params["solver"]
        else:
            #solvers = self._result.getSolvers ()
            if track != 0:
                solvers = self._result.getSolversForTrack(track)
            else:
                solvers = self._result.getSolversForGroup(group)


        for solv in solvers:
            smtcalls,timeouted,satis,unk,nsatis,errors,time,total = self._result.getSummaryForSolverTrack (solv,track) if track != 0 else self._result.getSummaryForSolverGroup (solv,group) 
            #smtcalls,timeouted,satis,unk,nsatis,errors,time,total = self._result.getSummaryForSolverTrack (solv,params["track"])
            
            rdata[solv] = {"satis" : satis,
                           "unk" : unk,
                           "nsatis" : nsatis
            }
            
        if "format" not in params:
            return webserver.views.jsonview.JSONView (rdata)
        else:
            form = params["format"][0]
            if form == "png":
                
                from matplotlib.figure import Figure
                from io import BytesIO
                import numpy as np
                fig = Figure()
                ax = fig.subplots()
                index = np.arange(3)
                bar_width = 0.8/len(solvers)
                opacity = 0.8
                c = 0
                for p in rdata.keys():
                    r = rdata[p]
                    res = (r["satis"],r["unk"],r["nsatis"])
                    ax.bar(index+c*bar_width, res, bar_width,
                                     alpha=opacity,
                                     label=self._solverNameMap(p))
                    c = c+1

                ax.set_xticks(index)
                ax.set_xticklabels(["Satis","Unknown","NSatis"])
                ax.legend()
                # Save it to a temporary buffer.
                buf = BytesIO()
                fig.savefig(buf, format="png")
                return webserver.views.PNGView.PNGView (buf)
            else:
                return webserver.views.TextView.ErrorText ("Unknown format")


    #scattered plots
    def generateScatteredPlots(self,params,to_zip=None,all_instances=False):
        no_unk = False


        """if no_unk:
            results_for_solver_func=self._result.getResultForSolverGroup
            results_for_solver_track_func=self._result.getResultForSolverTrack
        else:
            results_for_solver_func=self._result.getResultForSolverGroupNoUnk
            results_for_solver_track_func=self._result.getResultForSolverTrackNoUnk


        rdata = {}
        avtracks = self._result.getTrackIds()
        activeGroup = list( self._result.getTrackInfo().keys() )[0]
        activeTrack = None

        basis = "group"
        apl_fun = self._result.getSummaryForSolverGroup
        iterationData = list(self._result.getTrackInfo().keys())

        # analysis based on benchmark set, track or instances
        if "basis" in params:
            if params["basis"][0] == "instances":
                basis = "instances"
                groups = list(self._result.getTrackInfo().keys())
                iterationData = []
                for g in groups:
                    iterationData+=self._result.getInstanceIdsForGroup(g)
                apl_fun = self._result.getResultForSolverInstance # collect all instance data for a solver --> this is only working if no errors within a solver!
            elif params["basis"][0] == "tracks":
                basis = "tracks"
                iterationData = [t[0][0] for t in self._result.getTrackInfo().values()]
                apl_fun = self._result.getSummaryForSolverTrack
        # fetch solvers
        if "solvers" in params:
            solvers = params["solvers"][:2]
        else:
            solvers = self._result.getSolvers ()[:2]
        rdata = []
        for d in iterationData:
            currentTuple = []
            for s in solvers:
                if basis in ["tracks","group"]:
                    currentTuple.append(apl_fun(s,d)[6])
                elif basis == "instances":
                    currentTuple.append(apl_fun(s,d)[2].time)

            rdata.append(tuple(currentTuple))
        """

        if "solvers" in params:
            solvers = params["solvers"][:2]
        else:
            solvers = self._result.getSolvers ()[:2]

        # do it for a single group first...
        if "bgroup" in params:
            groups = [params["bgroup"][0]]
        else: 
            groups = list(self._result.getTrackInfo().keys())


        filePaths = dict()
        for s in solvers:
            filePaths[s] = []


        data = dict()
        for bgroup in groups:
            for s in solvers:
                res = self._result.getResultForSolverGroupAndFilePath(s,bgroup)
                for t in res:
                    if t[1] not in data:
                        data[t[1]] = [t[2].time]
                    else: 
                        data[t[1]] = data[t[1]] + [t[2].time]

                        if data[t[1]][0] <= data[t[1]][1]:
                            filePaths[solvers[0]] += [t[3][len("/home/mku/wordbenchmarks/"):]]
                        else: 
                            filePaths[solvers[1]] += [t[3][len("/home/mku/wordbenchmarks/"):]]
        print(len(data.values()))
        """
        print("start copy!")
        import os
        import shutil  
        folder = "split_groups"
        #for s in solvers:
        #    os.mkdir(folder+"/"+str(s))

        for s in filePaths:
            for source in filePaths[s]:
                #print(source)
                #os.makedirs()
                filename = os.path.basename(source)
                modelFolder = source[len("models/"):-len(filename)]
                destination = folder + "/" + str(s) + "/" + modelFolder + "" + filename
                if not os.path.exists(folder + "/" + str(s) + "/" + modelFolder):
                    os.makedirs(folder + "/" + str(s) + "/" + modelFolder)
                #print("cp " + source + " " + destination)
                shutil.copyfile(source, destination) 

        print("copy done!")
        """

        if "format" not in params:
            return webserver.views.jsonview.JSONView (data)
        else:
            form = params["format"][0]
            if form == "png":
                from matplotlib.figure import Figure
                from matplotlib.font_manager import FontProperties
                from io import BytesIO
                import itertools
                import random


                # colour setup
                colors = ["#25333D","#0065AB","#8939AD","#007E7A","#CD3517","#318700","#80746D","#FF9A69","#00D4B8","#85C81A", #none_5_z3str3
                  "#AC75C6","#0F1E82","#A3EDF6","#FFB38F","#49AFD9",]

                # grey setup
                #colors = ["#8a8a8a","#4a4a4a","#c9c9c9","#d6d6d6","#b0b0b0"]

                # 4 color setup
                # seq, str3, cvc4, str4
                #colors = ["#364f6b","#3fc1c9","#ffb6b9","#fc5185"]

                colors = ["#fc5185","#ffb6b9","#3fc1c9","#ffb6b9"]

                # extend the colors 
                r = lambda: random.randint(0,255)
                colorGen = lambda : '#%02X%02X%02X' % (r(),r(),r())
                while len(colors) < 26:
                  newColor = colorGen()
                  if newColor not in colors:
                    colors+=[newColor]



                it_cols = itertools.cycle(colors)

                fig = Figure(figsize=(6,3))
                ax = fig.subplots()

                fontP = FontProperties()
                fontP.set_size('small')

                dataX_a = []
                dataX_b = []
                dataY_a = []
                dataY_b = []


                for i in data.values():
                    if i[0] <= i[1]:
                        dataX_a+=[i[0]]
                        dataY_a+=[i[1]]
                    else:
                        dataX_b+=[i[0]]
                        dataY_b+=[i[1]]

                print(solvers[0] + ": " + str(len(dataX_a)))
                print(solvers[1] + ": " + str(len(dataY_b)))

                max_x = 20#max([max(dataX_a),max(dataX_b)])
                max_y = 20#max([max(dataY_a),max(dataY_b)])

                #ax.plot ([0,max_x],[0,max_y],'-',linewidth=0.25,color=next(it_cols))#,marker='.')
                #next(it_cols)
                ax.scatter (dataX_a,dataY_a,linewidth=0.01,color=next(it_cols),marker='.')
                ax.scatter (dataX_b,dataY_b,linewidth=0.01,color=next(it_cols),marker='.')
                #ax.fill_between(range(0,len(data)),data, color=current_color,alpha=0.15)
                #lgd = ax.legend(fancybox=True,bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left', ncol=2, mode="expand", borderaxespad=0.,frameon=False)#loc='upper left', bbox_to_anchor=(0, 0, 0, 0))#bbox_to_anchor=(0.4, 1.1))
                ax.spines['top'].set_visible(False)
                ax.spines['right'].set_visible(False)
                ax.spines['bottom'].set_visible(False)
                ax.spines['left'].set_visible(False)
                ax.xaxis.grid(color='black', linestyle='dashdot', linewidth=0.1)
                ax.yaxis.grid(color='black', linestyle='dashdot', linewidth=0.1)
                ax.set_xlabel (self._solverNameMap(solvers[0]))
                ax.set_ylabel (self._solverNameMap(solvers[1]))
                # Save it to a temporary buffer.
                buf = BytesIO()

                if to_zip != None:
                    if activeTrack != None:
                        name = activeTrack
                    else:
                        name = activeGroup
                    fileName = name.lower().replace(" ", "")+'.png'
                    fig.savefig(to_zip+"/"+fileName,format="png",dpi=160,prop=fontP, bbox_inches='tight')
                    #fig.savefig(to_zip+"/"+fileName,format="png",dpi=160,prop=fontP,bbox_extra_artists=(lgd,), bbox_inches='tight')
                    return to_zip+"/"+fileName 
                else:
                    fig.savefig(buf, format="png",dpi=160,prop=fontP, bbox_inches='tight')
                    return webserver.views.PNGView.PNGView (buf)
            else:
                return webserver.views.TextView.ErrorText ("Unknown format")