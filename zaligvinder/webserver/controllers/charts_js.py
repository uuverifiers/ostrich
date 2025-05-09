import webserver.views.jsonview
import webserver.views.PNGView
import webserver.views.TextView




class ChartControllerJS:
    def __init__(self,result):
        self._result = result
        
    def generateCactusData(self,params,activeGroup,no_unk=False):
        if no_unk:
            results_for_solver_func=self._result.getResultForSolverGroup
            results_for_solver_track_func=self._result.getResultForSolverTrack
        else:
            results_for_solver_func=self._result.getResultForSolverGroupNoUnk
            results_for_solver_track_func=self._result.getResultForSolverTrackNoUnk


        rdata = {}
        if "solver" in params:
            solvers = params["solver"]
        else:
            solvers = self._result.getSolvers ()

        for solv in solvers:
            list = []
            avtracks = self._result.getTrackIds()

            if "track" not in params or int(str(params["track"][0])) not in avtracks:
                res = results_for_solver_func(solv,activeGroup)
            else:
                track = int(str(params["track"][0]))
                res = results_for_solver_track_func(solv,track)

            s = 0
            for i,data in enumerate(res):
                s = s+data[2].time
                list.append (s)

            rdata[solv] = list

        return rdata
        #return webserver.views.jsonview.JSONView (rdata)

        #return webserver.views.TextView.TextView (str(rdata))


    def generateCactusJSData(self,params,dataName="data"):
        rdata = self.generateCactusData(params)

        labels = "labels: []" # "labels: " + str(list(rdata.keys()))
        #series = "series: " + str([list(rdata[s]) for s in rdata])
        series = "series: ["
        for s in rdata:
            series+="{ \"name\": \""+str(s)+"\", \"data\":"+str(list(rdata[s]))+"},\n"
        series+= "]"


        
        data = "" + labels + ",\n" + series + "\n "

        outputstr="var " + dataName + " = {" + data + "};"
        return outputstr

    def generateDefaultOptionsJS(self):
        return "var options = { showPoint: false, height: '200px', showArea: true,axisX: {showGrid: false, showLabel: true,offset: 100}, axisY: {offset: 60,labelInterpolationFnc: function(value) {return '' + value + 'ms';}},plugins: [Chartist.plugins.legend({})] };"

    def generateCactus(self,params):
        outputstr=self.stupidHeader()
        outputstr+= '''<div class="ct-chart ct-golden-section" id="chart1"></div><script>'''
        outputstr+=self.generateCactusJSData(params,"data")
        outputstr+=self.generateDefaultOptionsJS()
        outputstr+="new Chartist.Line('#chart1', data,options);"
        outputstr+= '''</script>'''
        outputstr+=self.stupidFooter()
        return webserver.views.TextView.TextView (outputstr)

    def generateCactusAllTracks(self,params):
        outputstr=self.stupidHeader()

        avtracks = self._result.getTrackIds()
        for tid in avtracks:
            outputstr+= '''<div class="ct-chart" id="chart''' +str(tid) + '''"></div>\n'''

        outputstr+="<script>\n" + self.generateDefaultOptionsJS()
        for tid in avtracks:
             outputstr+=self.generateCactusJSData({"track":str(tid)},"data"+str(tid))
             outputstr+="new Chartist.Line('#chart"+str(tid)+"', data"+str(tid)+",options);"
        outputstr+="</script>"

        outputstr+=self.stupidFooter()
        return webserver.views.TextView.TextView (outputstr)

    def generateDistributionData (self,params,activeGroup):
        rdata = {}
        if "solver" in params:
            solvers = params["solver"]
        else:
            solvers = self._result.getSolvers ()

        avtracks = self._result.getTrackIds()
        
        for solv in solvers:

            if "track" not in params or int(str(params["track"][0])) not in avtracks:
                smtcalls,timeouted,satis,unk,nsatis,errors,time,total = self._result.getSummaryForSolverGroup (solv,activeGroup)
            else:
                track = int(str(params["track"][0]))
                smtcalls,timeouted,satis,unk,nsatis,errors,time,total = self._result.getSummaryForSolverTrack(solv,track)
                   
            
            rdata[solv] = {"satis" : satis,
                           "unk" : unk,
                           "nsatis" : nsatis}
        return rdata
    
    def generateDistribution(self,params):
        rdata = self.generateDistributionData(params)

        outputstr=self.stupidHeader()
        outputstr+= '''<div class="ct-chart-bar ct-golden-section" id="chart1"></div><script>'''

        satis = [] 
        unk = []
        nsatis = []

        for s in rdata:
            satis.append(rdata[s]["satis"])
            unk.append(rdata[s]["unk"])
            nsatis.append(rdata[s]["nsatis"])

        accData = {"satisfiable":satis,"unsatisfiable":nsatis,"unknown":unk}
        labels = "labels: " + str([str(s) for s in rdata]) #str(list(rdata.keys()))

        series = '''series: [ \n'''
        for label in accData:
            series+='''{ "name": "''' + label + '''", "data": '''  + str(accData[label]) + '''},\n'''
        series+="]"

        data = "" + labels + ",\n" + series + "\n "

        outputstr+="\nvar data = {" + data + "};\n"

        outputstr+="var options = {fullWidth: true,chartPadding: {right: 40}, plugins: [Chartist.plugins.legend({})]};"


        outputstr+="new Chartist.Bar('#chart1',data,options);"
        outputstr+= '''</script>'''
        outputstr+=self.stupidFooter()

        return webserver.views.TextView.TextView (outputstr)

    def generateCactusGraph(self,params,divName="chart1",activeGroup="",no_unk=False):
        rdata = self.generateCactusData(params,activeGroup,no_unk)

        labels = "labels: []" # "labels: " + str(list(rdata.keys()))
        #series = "series: " + str([list(rdata[s]) for s in rdata])
        series = "series: ["
        for s in rdata:
            series+="{ \"name\": \""+str(s)+"\", \"data\":"+str(list(rdata[s]))+"},\n"
        series+= "]"


        data = dict()
        data["data"+str(divName)] = "" + labels + ",\n" + series + "\n "
        data["options"+str(divName)] = "showPoint: false, fullWidth: true, chartPadding: {right: 40}, height: '200px', showArea: true,axisX: {showGrid: false, showLabel: true}, axisY: {offset: 60,labelInterpolationFnc: function(value) {return value + 'ms';}},plugins: [Chartist.plugins.legend({})]"
        return data


    def generateDistributionGraph(self,params,divName="chart1",activeGroup="",solvers=None):
        rdata = self.generateDistributionData(params,activeGroup)
        satis = [] 
        unk = []
        nsatis = []

        if solvers == None:
            solvers = self._result.getSolvers()

        for s in solvers:
            satis.append(rdata[s]["satis"])
            unk.append(rdata[s]["unk"])
            nsatis.append(rdata[s]["nsatis"])

        accData = {"satisfiable":satis,"unsatisfiable":nsatis,"unknown":unk}
        labels = "labels: " + str([str(s) for s in rdata])

        series = '''series: [ \n'''
        for name in accData:
            series+='''{ "name": "''' + name + '''", "data": '''  + str(accData[name]) + '''},\n'''
        series+="]"

        data = dict()
        data["data"+str(divName)] = "" + labels + ",\n" + series + "\n "
        data["options"+str(divName)] =  "fullWidth: true,chartPadding: {right: 40}, plugins: [Chartist.plugins.legend({})]"
        
        return data

    def generatePieGraphForSolver(self,params,divName="chart1",solver=None,activeGroup=""):
        if solver == None:
            if "solver" in params:
                params["solver"] = [params["solver"][0]]
            else:
                params["solver"] = [self._result.getSolvers()[0]]
        else:
            params["solver"] = [solver]

        s = params["solver"][0]
        satis = [] 
        unk = []
        nsatis = []

        rdata = self.generateDistributionData(params,activeGroup)
        satis.append(rdata[s]["satis"])
        unk.append(rdata[s]["unk"])
        nsatis.append(rdata[s]["nsatis"])

        labels = "labels: " + str(['sat','unsat','unknow']) #str(list(rdata.keys()))
        series = "series: " + str(satis+nsatis+unk)

        data = dict()
        data["data"+str(divName)] = "" + labels + ",\n" + series + "\n "
        data["options"+str(divName)] = "showLabel: false,plugins: [Chartist.plugins.legend()]"

        return data 


    def generatePie(self,params):
        if "solver" in params:
            params["solver"] = [params["solver"][0]]
        else:
            params["solver"] = [self._result.getSolvers()[0]] 

        rdata = self.generateDistributionData(params)
        s = params["solver"][0]

        outputstr=self.stupidHeader()
        outputstr+= '''<div class="ct-chart ct-golden-section" id="chart1"></div><script>'''

        satis = [] 
        unk = []
        nsatis = []

        satis.append(rdata[s]["satis"])
        unk.append(rdata[s]["unk"])
        nsatis.append(rdata[s]["nsatis"])

        labels = "labels: " + str(['sat','unsat','unknow']) #str(list(rdata.keys()))
        series = "series: " + str(satis+nsatis+unk)

        data = "" + labels + ",\n" + series + "\n "

        outputstr+="var data = {" + data + "};"

        outputstr+="var options = {};"


        outputstr+="new Chartist.Pie('#chart1', data,options);"
        outputstr+= '''</script>'''
        outputstr+=self.stupidFooter()

        return webserver.views.TextView.TextView (outputstr)



    def stupidHeader(self):
        return '''
        <!DOCTYPE html>
        <html>
          <head>
            <title></title>
            <style>.ct-double-octave:after,.ct-golden-section:after,.ct-major-eleventh:after,.ct-major-second:after,.ct-major-seventh:after,.ct-major-sixth:after,.ct-major-tenth:after,.ct-major-third:after,.ct-major-twelfth:after,.ct-minor-second:after,.ct-minor-seventh:after,.ct-minor-sixth:after,.ct-minor-third:after,.ct-octave:after,.ct-perfect-fifth:after,.ct-perfect-fourth:after,.ct-square:after{content:"";clear:both}.ct-label{fill:rgba(0,0,0,.4);color:rgba(0,0,0,.4);font-size:.75rem;line-height:1}.ct-chart-bar .ct-label,.ct-chart-line .ct-label{display:block;display:-webkit-box;display:-moz-box;display:-ms-flexbox;display:-webkit-flex;display:flex}.ct-chart-donut .ct-label,.ct-chart-pie .ct-label{dominant-baseline:central}.ct-label.ct-horizontal.ct-start{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-label.ct-horizontal.ct-end{-webkit-box-align:flex-start;-webkit-align-items:flex-start;-ms-flex-align:flex-start;align-items:flex-start;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-label.ct-vertical.ct-start{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:flex-end;-webkit-justify-content:flex-end;-ms-flex-pack:flex-end;justify-content:flex-end;text-align:right;text-anchor:end}.ct-label.ct-vertical.ct-end{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-chart-bar .ct-label.ct-horizontal.ct-start{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:center;-webkit-justify-content:center;-ms-flex-pack:center;justify-content:center;text-align:center;text-anchor:start}.ct-chart-bar .ct-label.ct-horizontal.ct-end{-webkit-box-align:flex-start;-webkit-align-items:flex-start;-ms-flex-align:flex-start;align-items:flex-start;-webkit-box-pack:center;-webkit-justify-content:center;-ms-flex-pack:center;justify-content:center;text-align:center;text-anchor:start}.ct-chart-bar.ct-horizontal-bars .ct-label.ct-horizontal.ct-start{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-chart-bar.ct-horizontal-bars .ct-label.ct-horizontal.ct-end{-webkit-box-align:flex-start;-webkit-align-items:flex-start;-ms-flex-align:flex-start;align-items:flex-start;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-chart-bar.ct-horizontal-bars .ct-label.ct-vertical.ct-start{-webkit-box-align:center;-webkit-align-items:center;-ms-flex-align:center;align-items:center;-webkit-box-pack:flex-end;-webkit-justify-content:flex-end;-ms-flex-pack:flex-end;justify-content:flex-end;text-align:right;text-anchor:end}.ct-chart-bar.ct-horizontal-bars .ct-label.ct-vertical.ct-end{-webkit-box-align:center;-webkit-align-items:center;-ms-flex-align:center;align-items:center;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:end}.ct-grid{stroke:rgba(0,0,0,.2);stroke-width:1px;stroke-dasharray:2px}.ct-grid-background{fill:none}.ct-point{stroke-width:10px;stroke-linecap:round}.ct-line{fill:none;stroke-width:4px}.ct-area{stroke:none;fill-opacity:.1}.ct-bar{fill:none;stroke-width:10px}.ct-slice-donut{fill:none;stroke-width:60px}.ct-series-a .ct-bar,.ct-series-a .ct-line,.ct-series-a .ct-point,.ct-series-a .ct-slice-donut{stroke:#d70206}.ct-series-a .ct-area,.ct-series-a .ct-slice-donut-solid,.ct-series-a .ct-slice-pie{fill:#d70206}.ct-series-b .ct-bar,.ct-series-b .ct-line,.ct-series-b .ct-point,.ct-series-b .ct-slice-donut{stroke:#f05b4f}.ct-series-b .ct-area,.ct-series-b .ct-slice-donut-solid,.ct-series-b .ct-slice-pie{fill:#f05b4f}.ct-series-c .ct-bar,.ct-series-c .ct-line,.ct-series-c .ct-point,.ct-series-c .ct-slice-donut{stroke:#f4c63d}.ct-series-c .ct-area,.ct-series-c .ct-slice-donut-solid,.ct-series-c .ct-slice-pie{fill:#f4c63d}.ct-series-d .ct-bar,.ct-series-d .ct-line,.ct-series-d .ct-point,.ct-series-d .ct-slice-donut{stroke:#d17905}.ct-series-d .ct-area,.ct-series-d .ct-slice-donut-solid,.ct-series-d .ct-slice-pie{fill:#d17905}.ct-series-e .ct-bar,.ct-series-e .ct-line,.ct-series-e .ct-point,.ct-series-e .ct-slice-donut{stroke:#453d3f}.ct-series-e .ct-area,.ct-series-e .ct-slice-donut-solid,.ct-series-e .ct-slice-pie{fill:#453d3f}.ct-series-f .ct-bar,.ct-series-f .ct-line,.ct-series-f .ct-point,.ct-series-f .ct-slice-donut{stroke:#59922b}.ct-series-f .ct-area,.ct-series-f .ct-slice-donut-solid,.ct-series-f .ct-slice-pie{fill:#59922b}.ct-series-g .ct-bar,.ct-series-g .ct-line,.ct-series-g .ct-point,.ct-series-g .ct-slice-donut{stroke:#0544d3}.ct-series-g .ct-area,.ct-series-g .ct-slice-donut-solid,.ct-series-g .ct-slice-pie{fill:#0544d3}.ct-series-h .ct-bar,.ct-series-h .ct-line,.ct-series-h .ct-point,.ct-series-h .ct-slice-donut{stroke:#6b0392}.ct-series-h .ct-area,.ct-series-h .ct-slice-donut-solid,.ct-series-h .ct-slice-pie{fill:#6b0392}.ct-series-i .ct-bar,.ct-series-i .ct-line,.ct-series-i .ct-point,.ct-series-i .ct-slice-donut{stroke:#f05b4f}.ct-series-i .ct-area,.ct-series-i .ct-slice-donut-solid,.ct-series-i .ct-slice-pie{fill:#f05b4f}.ct-series-j .ct-bar,.ct-series-j .ct-line,.ct-series-j .ct-point,.ct-series-j .ct-slice-donut{stroke:#dda458}.ct-series-j .ct-area,.ct-series-j .ct-slice-donut-solid,.ct-series-j .ct-slice-pie{fill:#dda458}.ct-series-k .ct-bar,.ct-series-k .ct-line,.ct-series-k .ct-point,.ct-series-k .ct-slice-donut{stroke:#eacf7d}.ct-series-k .ct-area,.ct-series-k .ct-slice-donut-solid,.ct-series-k .ct-slice-pie{fill:#eacf7d}.ct-series-l .ct-bar,.ct-series-l .ct-line,.ct-series-l .ct-point,.ct-series-l .ct-slice-donut{stroke:#86797d}.ct-series-l .ct-area,.ct-series-l .ct-slice-donut-solid,.ct-series-l .ct-slice-pie{fill:#86797d}.ct-series-m .ct-bar,.ct-series-m .ct-line,.ct-series-m .ct-point,.ct-series-m .ct-slice-donut{stroke:#b2c326}.ct-series-m .ct-area,.ct-series-m .ct-slice-donut-solid,.ct-series-m .ct-slice-pie{fill:#b2c326}.ct-series-n .ct-bar,.ct-series-n .ct-line,.ct-series-n .ct-point,.ct-series-n .ct-slice-donut{stroke:#6188e2}.ct-series-n .ct-area,.ct-series-n .ct-slice-donut-solid,.ct-series-n .ct-slice-pie{fill:#6188e2}.ct-series-o .ct-bar,.ct-series-o .ct-line,.ct-series-o .ct-point,.ct-series-o .ct-slice-donut{stroke:#a748ca}.ct-series-o .ct-area,.ct-series-o .ct-slice-donut-solid,.ct-series-o .ct-slice-pie{fill:#a748ca}.ct-square{display:block;position:relative;width:100%}.ct-square:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:100%}.ct-square:after{display:table}.ct-square>svg{display:block;position:absolute;top:0;left:0}.ct-minor-second{display:block;position:relative;width:100%}.ct-minor-second:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:93.75%}.ct-minor-second:after{display:table}.ct-minor-second>svg{display:block;position:absolute;top:0;left:0}.ct-major-second{display:block;position:relative;width:100%}.ct-major-second:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:88.8888888889%}.ct-major-second:after{display:table}.ct-major-second>svg{display:block;position:absolute;top:0;left:0}.ct-minor-third{display:block;position:relative;width:100%}.ct-minor-third:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:83.3333333333%}.ct-minor-third:after{display:table}.ct-minor-third>svg{display:block;position:absolute;top:0;left:0}.ct-major-third{display:block;position:relative;width:100%}.ct-major-third:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:80%}.ct-major-third:after{display:table}.ct-major-third>svg{display:block;position:absolute;top:0;left:0}.ct-perfect-fourth{display:block;position:relative;width:100%}.ct-perfect-fourth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:75%}.ct-perfect-fourth:after{display:table}.ct-perfect-fourth>svg{display:block;position:absolute;top:0;left:0}.ct-perfect-fifth{display:block;position:relative;width:100%}.ct-perfect-fifth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:66.6666666667%}.ct-perfect-fifth:after{display:table}.ct-perfect-fifth>svg{display:block;position:absolute;top:0;left:0}.ct-minor-sixth{display:block;position:relative;width:100%}.ct-minor-sixth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:62.5%}.ct-minor-sixth:after{display:table}.ct-minor-sixth>svg{display:block;position:absolute;top:0;left:0}.ct-golden-section{display:block;position:relative;width:100%}.ct-golden-section:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:61.804697157%}.ct-golden-section:after{display:table}.ct-golden-section>svg{display:block;position:absolute;top:0;left:0}.ct-major-sixth{display:block;position:relative;width:100%}.ct-major-sixth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:60%}.ct-major-sixth:after{display:table}.ct-major-sixth>svg{display:block;position:absolute;top:0;left:0}.ct-minor-seventh{display:block;position:relative;width:100%}.ct-minor-seventh:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:56.25%}.ct-minor-seventh:after{display:table}.ct-minor-seventh>svg{display:block;position:absolute;top:0;left:0}.ct-major-seventh{display:block;position:relative;width:100%}.ct-major-seventh:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:53.3333333333%}.ct-major-seventh:after{display:table}.ct-major-seventh>svg{display:block;position:absolute;top:0;left:0}.ct-octave{display:block;position:relative;width:100%}.ct-octave:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:50%}.ct-octave:after{display:table}.ct-octave>svg{display:block;position:absolute;top:0;left:0}.ct-major-tenth{display:block;position:relative;width:100%}.ct-major-tenth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:40%}.ct-major-tenth:after{display:table}.ct-major-tenth>svg{display:block;position:absolute;top:0;left:0}.ct-major-eleventh{display:block;position:relative;width:100%}.ct-major-eleventh:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:37.5%}.ct-major-eleventh:after{display:table}.ct-major-eleventh>svg{display:block;position:absolute;top:0;left:0}.ct-major-twelfth{display:block;position:relative;width:100%}.ct-major-twelfth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:33.3333333333%}.ct-major-twelfth:after{display:table}.ct-major-twelfth>svg{display:block;position:absolute;top:0;left:0}.ct-double-octave{display:block;position:relative;width:100%}.ct-double-octave:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:25%}.ct-double-octave:after{display:table}.ct-double-octave>svg{display:block;position:absolute;top:0;left:0}</style>
        <style>
       .ct-chart {
           position: relative;
       }
       .ct-legend {
           position: relative;
           z-index: 10;
           list-style: none;
           text-align: center;
       }
       .ct-legend li {
           position: relative;
           padding-left: 23px;
           margin-right: 10px;
           margin-bottom: 3px;
           cursor: pointer;
           display: inline-block;
       }
       .ct-legend li:before {
           width: 12px;
           height: 12px;
           position: absolute;
           left: 0;
           content: '';
           border: 3px solid transparent;
           border-radius: 2px;
       }
       .ct-legend li.inactive:before {
           background: transparent;
       }
       .ct-legend.ct-legend-inside {
           position: absolute;
           top: 0;
           right: 0;
       }
       .ct-legend.ct-legend-inside li{
           display: block;
           margin: 0;
       }
       .ct-legend .ct-series-0:before {
           background-color: hsl(198, 100%, 24%);
           border-color: hsl(198, 100%, 24%);
       }
       .ct-legend .ct-series-1:before {
           background-color: hsl(198, 0%, 27%);
           border-color: hsl(198, 0%, 27%);
       }
       .ct-legend .ct-series-2:before {
           background-color: hsl(282, 43%, 54%);
           border-color: hsl(282, 43%, 54%);
       }
       .ct-legend .ct-series-3:before {
           background-color: hsl(198, 54%, 92%);
           border-color: hsl(198, 54%, 92%);
       }
       .ct-legend .ct-series-4:before {
           background-color: hsl(198, 58%, 78%);
           border-color: hsl(198, 58%, 78%);
       }

        .ct-series-a .ct-point, .ct-series-a .ct-line, .ct-series-a .ct-bar, .ct-series-a .ct-slice-donut {
          stroke: hsl(198, 100%, 24%); }

        .ct-series-a .ct-slice-pie, .ct-series-a .ct-slice-donut-solid, .ct-series-a .ct-area {
          fill: hsl(198, 100%, 24%); }

        .ct-series-b .ct-point, .ct-series-b .ct-line, .ct-series-b .ct-bar, .ct-series-b .ct-slice-donut {
          stroke: hsl(198, 0%, 27%); }

        .ct-series-b .ct-slice-pie, .ct-series-b .ct-slice-donut-solid, .ct-series-b .ct-area {
          fill: hsl(198, 0%, 27%); }

        .ct-series-c .ct-point, .ct-series-c .ct-line, .ct-series-c .ct-bar, .ct-series-c .ct-slice-donut {
          stroke: hsl(282, 43%, 54%); }

        .ct-series-c .ct-slice-pie, .ct-series-c .ct-slice-donut-solid, .ct-series-c .ct-area {
          fill: hsl(282, 43%, 54%); }

        .ct-series-d .ct-point, .ct-series-d .ct-line, .ct-series-d .ct-bar, .ct-series-d .ct-slice-donut {
          stroke: hsl(198, 54%, 92%); }

        .ct-series-d .ct-slice-pie, .ct-series-d .ct-slice-donut-solid, .ct-series-d .ct-area {
          fill: hsl(198, 54%, 92%); }

        .ct-series-e .ct-point, .ct-series-e .ct-line, .ct-series-e .ct-bar, .ct-series-e .ct-slice-donut {
          stroke: hsl(198, 58%, 78%); }

        .ct-series-e .ct-slice-pie, .ct-series-e .ct-slice-donut-solid, .ct-series-e .ct-area {
          fill: hsl(198, 58%, 78%); }

        .ct-series-f .ct-point, .ct-series-f .ct-line, .ct-series-f .ct-bar, .ct-series-f .ct-slice-donut {
          stroke: hsl(198, 0%, 45%); }

        .ct-series-f .ct-slice-pie, .ct-series-f .ct-slice-donut-solid, .ct-series-f .ct-area {
          fill: hsl(198, 0%, 45%); }

        .ct-series-g .ct-point, .ct-series-g .ct-line, .ct-series-g .ct-bar, .ct-series-g .ct-slice-donut {
          stroke: hsl(14, 91%, 55%); }

        .ct-series-g .ct-slice-pie, .ct-series-g .ct-slice-donut-solid, .ct-series-g .ct-area {
          fill: hsl(14, 91%, 55%); }

        .ct-series-h .ct-point, .ct-series-h .ct-line, .ct-series-h .ct-bar, .ct-series-h .ct-slice-donut {
          stroke: hsl(14, 83%, 84%); }

        .ct-series-h .ct-slice-pie, .ct-series-h .ct-slice-donut-solid, .ct-series-h .ct-area {
          fill: hsl(14, 83%, 84%); }

        .ct-series-i .ct-point, .ct-series-i .ct-line, .ct-series-i .ct-bar, .ct-series-i .ct-slice-donut {
          stroke: #f05b4f; }

        .ct-series-i .ct-slice-pie, .ct-series-i .ct-slice-donut-solid, .ct-series-i .ct-area {
          fill: #f05b4f; }

        .ct-series-j .ct-point, .ct-series-j .ct-line, .ct-series-j .ct-bar, .ct-series-j .ct-slice-donut {
          stroke: #dda458; }

        .ct-series-j .ct-slice-pie, .ct-series-j .ct-slice-donut-solid, .ct-series-j .ct-area {
          fill: #dda458; }

        .ct-series-k .ct-point, .ct-series-k .ct-line, .ct-series-k .ct-bar, .ct-series-k .ct-slice-donut {
          stroke: #eacf7d; }

        .ct-series-k .ct-slice-pie, .ct-series-k .ct-slice-donut-solid, .ct-series-k .ct-area {
          fill: #eacf7d; }

        .ct-series-l .ct-point, .ct-series-l .ct-line, .ct-series-l .ct-bar, .ct-series-l .ct-slice-donut {
          stroke: #86797d; }

        .ct-series-l .ct-slice-pie, .ct-series-l .ct-slice-donut-solid, .ct-series-l .ct-area {
          fill: #86797d; }
    </style>

          </head>
          <body>
            <script src="/files/libs/chartist/dist/chartist.min.js"></script>
            <script src="/files/libs/chartist/chartist-plugin-legend.js"></script>
            '''

    def stupidFooter(self):
        return '''
          </body>
        </html>
        '''


    ## Clarity Design HACK!

    def cdl_test(self,params):
        outputstr = self.cdl_header()+self.cld_mainStart()+self.cld_navigation(params)+self.cld_trackPage(params)+self.cld_mainEnd()
        return webserver.views.TextView.TextView (outputstr)


    def cdl_header(self):
        return '''<!DOCTYPE html>
        <html>
        <head>
          <link rel="stylesheet" href="https://unpkg.com/@clr/ui/clr-ui.min.css" />
          <link rel="stylesheet" href="https://unpkg.com/clarity-icons/clarity-icons.min.css">
          <script src="https://unpkg.com/@webcomponents/custom-elements/custom-elements.min.js"></script>
          <script src="https://unpkg.com/clarity-icons/clarity-icons.min.js"></script>

                      <style>.ct-double-octave:after,.ct-golden-section:after,.ct-major-eleventh:after,.ct-major-second:after,.ct-major-seventh:after,.ct-major-sixth:after,.ct-major-tenth:after,.ct-major-third:after,.ct-major-twelfth:after,.ct-minor-second:after,.ct-minor-seventh:after,.ct-minor-sixth:after,.ct-minor-third:after,.ct-octave:after,.ct-perfect-fifth:after,.ct-perfect-fourth:after,.ct-square:after{content:"";clear:both}.ct-label{fill:rgba(0,0,0,.4);color:rgba(0,0,0,.4);font-size:.75rem;line-height:1}.ct-chart-bar .ct-label,.ct-chart-line .ct-label{display:block;display:-webkit-box;display:-moz-box;display:-ms-flexbox;display:-webkit-flex;display:flex}.ct-chart-donut .ct-label,.ct-chart-pie .ct-label{dominant-baseline:central}.ct-label.ct-horizontal.ct-start{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-label.ct-horizontal.ct-end{-webkit-box-align:flex-start;-webkit-align-items:flex-start;-ms-flex-align:flex-start;align-items:flex-start;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-label.ct-vertical.ct-start{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:flex-end;-webkit-justify-content:flex-end;-ms-flex-pack:flex-end;justify-content:flex-end;text-align:right;text-anchor:end}.ct-label.ct-vertical.ct-end{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-chart-bar .ct-label.ct-horizontal.ct-start{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:center;-webkit-justify-content:center;-ms-flex-pack:center;justify-content:center;text-align:center;text-anchor:start}.ct-chart-bar .ct-label.ct-horizontal.ct-end{-webkit-box-align:flex-start;-webkit-align-items:flex-start;-ms-flex-align:flex-start;align-items:flex-start;-webkit-box-pack:center;-webkit-justify-content:center;-ms-flex-pack:center;justify-content:center;text-align:center;text-anchor:start}.ct-chart-bar.ct-horizontal-bars .ct-label.ct-horizontal.ct-start{-webkit-box-align:flex-end;-webkit-align-items:flex-end;-ms-flex-align:flex-end;align-items:flex-end;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-chart-bar.ct-horizontal-bars .ct-label.ct-horizontal.ct-end{-webkit-box-align:flex-start;-webkit-align-items:flex-start;-ms-flex-align:flex-start;align-items:flex-start;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:start}.ct-chart-bar.ct-horizontal-bars .ct-label.ct-vertical.ct-start{-webkit-box-align:center;-webkit-align-items:center;-ms-flex-align:center;align-items:center;-webkit-box-pack:flex-end;-webkit-justify-content:flex-end;-ms-flex-pack:flex-end;justify-content:flex-end;text-align:right;text-anchor:end}.ct-chart-bar.ct-horizontal-bars .ct-label.ct-vertical.ct-end{-webkit-box-align:center;-webkit-align-items:center;-ms-flex-align:center;align-items:center;-webkit-box-pack:flex-start;-webkit-justify-content:flex-start;-ms-flex-pack:flex-start;justify-content:flex-start;text-align:left;text-anchor:end}.ct-grid{stroke:rgba(0,0,0,.2);stroke-width:1px;stroke-dasharray:2px}.ct-grid-background{fill:none}.ct-point{stroke-width:10px;stroke-linecap:round}.ct-line{fill:none;stroke-width:4px}.ct-area{stroke:none;fill-opacity:.1}.ct-bar{fill:none;stroke-width:10px}.ct-slice-donut{fill:none;stroke-width:60px}.ct-series-a .ct-bar,.ct-series-a .ct-line,.ct-series-a .ct-point,.ct-series-a .ct-slice-donut{stroke:#d70206}.ct-series-a .ct-area,.ct-series-a .ct-slice-donut-solid,.ct-series-a .ct-slice-pie{fill:#d70206}.ct-series-b .ct-bar,.ct-series-b .ct-line,.ct-series-b .ct-point,.ct-series-b .ct-slice-donut{stroke:#f05b4f}.ct-series-b .ct-area,.ct-series-b .ct-slice-donut-solid,.ct-series-b .ct-slice-pie{fill:#f05b4f}.ct-series-c .ct-bar,.ct-series-c .ct-line,.ct-series-c .ct-point,.ct-series-c .ct-slice-donut{stroke:#f4c63d}.ct-series-c .ct-area,.ct-series-c .ct-slice-donut-solid,.ct-series-c .ct-slice-pie{fill:#f4c63d}.ct-series-d .ct-bar,.ct-series-d .ct-line,.ct-series-d .ct-point,.ct-series-d .ct-slice-donut{stroke:#d17905}.ct-series-d .ct-area,.ct-series-d .ct-slice-donut-solid,.ct-series-d .ct-slice-pie{fill:#d17905}.ct-series-e .ct-bar,.ct-series-e .ct-line,.ct-series-e .ct-point,.ct-series-e .ct-slice-donut{stroke:#453d3f}.ct-series-e .ct-area,.ct-series-e .ct-slice-donut-solid,.ct-series-e .ct-slice-pie{fill:#453d3f}.ct-series-f .ct-bar,.ct-series-f .ct-line,.ct-series-f .ct-point,.ct-series-f .ct-slice-donut{stroke:#59922b}.ct-series-f .ct-area,.ct-series-f .ct-slice-donut-solid,.ct-series-f .ct-slice-pie{fill:#59922b}.ct-series-g .ct-bar,.ct-series-g .ct-line,.ct-series-g .ct-point,.ct-series-g .ct-slice-donut{stroke:#0544d3}.ct-series-g .ct-area,.ct-series-g .ct-slice-donut-solid,.ct-series-g .ct-slice-pie{fill:#0544d3}.ct-series-h .ct-bar,.ct-series-h .ct-line,.ct-series-h .ct-point,.ct-series-h .ct-slice-donut{stroke:#6b0392}.ct-series-h .ct-area,.ct-series-h .ct-slice-donut-solid,.ct-series-h .ct-slice-pie{fill:#6b0392}.ct-series-i .ct-bar,.ct-series-i .ct-line,.ct-series-i .ct-point,.ct-series-i .ct-slice-donut{stroke:#f05b4f}.ct-series-i .ct-area,.ct-series-i .ct-slice-donut-solid,.ct-series-i .ct-slice-pie{fill:#f05b4f}.ct-series-j .ct-bar,.ct-series-j .ct-line,.ct-series-j .ct-point,.ct-series-j .ct-slice-donut{stroke:#dda458}.ct-series-j .ct-area,.ct-series-j .ct-slice-donut-solid,.ct-series-j .ct-slice-pie{fill:#dda458}.ct-series-k .ct-bar,.ct-series-k .ct-line,.ct-series-k .ct-point,.ct-series-k .ct-slice-donut{stroke:#eacf7d}.ct-series-k .ct-area,.ct-series-k .ct-slice-donut-solid,.ct-series-k .ct-slice-pie{fill:#eacf7d}.ct-series-l .ct-bar,.ct-series-l .ct-line,.ct-series-l .ct-point,.ct-series-l .ct-slice-donut{stroke:#86797d}.ct-series-l .ct-area,.ct-series-l .ct-slice-donut-solid,.ct-series-l .ct-slice-pie{fill:#86797d}.ct-series-m .ct-bar,.ct-series-m .ct-line,.ct-series-m .ct-point,.ct-series-m .ct-slice-donut{stroke:#b2c326}.ct-series-m .ct-area,.ct-series-m .ct-slice-donut-solid,.ct-series-m .ct-slice-pie{fill:#b2c326}.ct-series-n .ct-bar,.ct-series-n .ct-line,.ct-series-n .ct-point,.ct-series-n .ct-slice-donut{stroke:#6188e2}.ct-series-n .ct-area,.ct-series-n .ct-slice-donut-solid,.ct-series-n .ct-slice-pie{fill:#6188e2}.ct-series-o .ct-bar,.ct-series-o .ct-line,.ct-series-o .ct-point,.ct-series-o .ct-slice-donut{stroke:#a748ca}.ct-series-o .ct-area,.ct-series-o .ct-slice-donut-solid,.ct-series-o .ct-slice-pie{fill:#a748ca}.ct-square{display:block;position:relative;width:100%}.ct-square:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:100%}.ct-square:after{display:table}.ct-square>svg{display:block;position:absolute;top:0;left:0}.ct-minor-second{display:block;position:relative;width:100%}.ct-minor-second:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:93.75%}.ct-minor-second:after{display:table}.ct-minor-second>svg{display:block;position:absolute;top:0;left:0}.ct-major-second{display:block;position:relative;width:100%}.ct-major-second:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:88.8888888889%}.ct-major-second:after{display:table}.ct-major-second>svg{display:block;position:absolute;top:0;left:0}.ct-minor-third{display:block;position:relative;width:100%}.ct-minor-third:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:83.3333333333%}.ct-minor-third:after{display:table}.ct-minor-third>svg{display:block;position:absolute;top:0;left:0}.ct-major-third{display:block;position:relative;width:100%}.ct-major-third:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:80%}.ct-major-third:after{display:table}.ct-major-third>svg{display:block;position:absolute;top:0;left:0}.ct-perfect-fourth{display:block;position:relative;width:100%}.ct-perfect-fourth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:75%}.ct-perfect-fourth:after{display:table}.ct-perfect-fourth>svg{display:block;position:absolute;top:0;left:0}.ct-perfect-fifth{display:block;position:relative;width:100%}.ct-perfect-fifth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:66.6666666667%}.ct-perfect-fifth:after{display:table}.ct-perfect-fifth>svg{display:block;position:absolute;top:0;left:0}.ct-minor-sixth{display:block;position:relative;width:100%}.ct-minor-sixth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:62.5%}.ct-minor-sixth:after{display:table}.ct-minor-sixth>svg{display:block;position:absolute;top:0;left:0}.ct-golden-section{display:block;position:relative;width:100%}.ct-golden-section:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:61.804697157%}.ct-golden-section:after{display:table}.ct-golden-section>svg{display:block;position:absolute;top:0;left:0}.ct-major-sixth{display:block;position:relative;width:100%}.ct-major-sixth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:60%}.ct-major-sixth:after{display:table}.ct-major-sixth>svg{display:block;position:absolute;top:0;left:0}.ct-minor-seventh{display:block;position:relative;width:100%}.ct-minor-seventh:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:56.25%}.ct-minor-seventh:after{display:table}.ct-minor-seventh>svg{display:block;position:absolute;top:0;left:0}.ct-major-seventh{display:block;position:relative;width:100%}.ct-major-seventh:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:53.3333333333%}.ct-major-seventh:after{display:table}.ct-major-seventh>svg{display:block;position:absolute;top:0;left:0}.ct-octave{display:block;position:relative;width:100%}.ct-octave:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:50%}.ct-octave:after{display:table}.ct-octave>svg{display:block;position:absolute;top:0;left:0}.ct-major-tenth{display:block;position:relative;width:100%}.ct-major-tenth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:40%}.ct-major-tenth:after{display:table}.ct-major-tenth>svg{display:block;position:absolute;top:0;left:0}.ct-major-eleventh{display:block;position:relative;width:100%}.ct-major-eleventh:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:37.5%}.ct-major-eleventh:after{display:table}.ct-major-eleventh>svg{display:block;position:absolute;top:0;left:0}.ct-major-twelfth{display:block;position:relative;width:100%}.ct-major-twelfth:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:33.3333333333%}.ct-major-twelfth:after{display:table}.ct-major-twelfth>svg{display:block;position:absolute;top:0;left:0}.ct-double-octave{display:block;position:relative;width:100%}.ct-double-octave:before{display:block;float:left;content:"";width:0;height:0;padding-bottom:25%}.ct-double-octave:after{display:table}.ct-double-octave>svg{display:block;position:absolute;top:0;left:0}</style>
        <style>
       .ct-chart {
           position: relative;
       }
       .ct-chart-line, .ct-chart-bar {
           min-height:200px;
       }
       .ct-vertical, .ct-label{
            font-size:10px;
       }
       .ct-legend {
           position: relative;
           z-index: 10;
           list-style: none;
           text-align: center;
       }
       .ct-legend li {
           position: relative;
           padding-left: 23px;
           margin-right: 10px;
           margin-bottom: 3px;
           cursor: pointer;
           display: inline-block;
       }
       .ct-legend li:before {
           width: 12px;
           height: 12px;
           position: absolute;
           left: 0;
           content: '';
           border: 3px solid transparent;
           border-radius: 2px;
       }
       .ct-legend li.inactive:before {
           background: transparent;
       }
       .ct-legend.ct-legend-inside {
           position: absolute;
           top: 0;
           right: 0;
       }
       .ct-legend.ct-legend-inside li{
           display: block;
           margin: 0;
       }
       .ct-legend .ct-series-0:before {
           background-color: hsl(198, 100%, 24%);
           border-color: hsl(198, 100%, 24%);
       }
       .ct-legend .ct-series-1:before {
           background-color: hsl(198, 0%, 27%);
           border-color: hsl(198, 0%, 27%);
       }
       .ct-legend .ct-series-2:before {
           background-color: hsl(282, 43%, 54%);
           border-color: hsl(282, 43%, 54%);
       }
       .ct-legend .ct-series-3:before {
           background-color: hsl(198, 54%, 92%);
           border-color: hsl(198, 54%, 92%);
       }
       .ct-legend .ct-series-4:before {
           background-color: hsl(198, 58%, 78%);
           border-color: hsl(198, 58%, 78%);
       }

        .ct-series-a .ct-point, .ct-series-a .ct-line, .ct-series-a .ct-bar, .ct-series-a .ct-slice-donut {
          stroke: hsl(198, 100%, 24%); }

        .ct-series-a .ct-slice-pie, .ct-series-a .ct-slice-donut-solid, .ct-series-a .ct-area {
          fill: hsl(198, 100%, 24%); }

        .ct-series-b .ct-point, .ct-series-b .ct-line, .ct-series-b .ct-bar, .ct-series-b .ct-slice-donut {
          stroke: hsl(198, 0%, 27%); }

        .ct-series-b .ct-slice-pie, .ct-series-b .ct-slice-donut-solid, .ct-series-b .ct-area {
          fill: hsl(198, 0%, 27%); }

        .ct-series-c .ct-point, .ct-series-c .ct-line, .ct-series-c .ct-bar, .ct-series-c .ct-slice-donut {
          stroke: hsl(282, 43%, 54%); }

        .ct-series-c .ct-slice-pie, .ct-series-c .ct-slice-donut-solid, .ct-series-c .ct-area {
          fill: hsl(282, 43%, 54%); }

        .ct-series-d .ct-point, .ct-series-d .ct-line, .ct-series-d .ct-bar, .ct-series-d .ct-slice-donut {
          stroke: hsl(198, 54%, 92%); }

        .ct-series-d .ct-slice-pie, .ct-series-d .ct-slice-donut-solid, .ct-series-d .ct-area {
          fill: hsl(198, 54%, 92%); }

        .ct-series-e .ct-point, .ct-series-e .ct-line, .ct-series-e .ct-bar, .ct-series-e .ct-slice-donut {
          stroke: hsl(198, 58%, 78%); }

        .ct-series-e .ct-slice-pie, .ct-series-e .ct-slice-donut-solid, .ct-series-e .ct-area {
          fill: hsl(198, 58%, 78%); }

        .ct-series-f .ct-point, .ct-series-f .ct-line, .ct-series-f .ct-bar, .ct-series-f .ct-slice-donut {
          stroke: hsl(198, 0%, 45%); }

        .ct-series-f .ct-slice-pie, .ct-series-f .ct-slice-donut-solid, .ct-series-f .ct-area {
          fill: hsl(198, 0%, 45%); }

        .ct-series-g .ct-point, .ct-series-g .ct-line, .ct-series-g .ct-bar, .ct-series-g .ct-slice-donut {
          stroke: hsl(14, 91%, 55%); }

        .ct-series-g .ct-slice-pie, .ct-series-g .ct-slice-donut-solid, .ct-series-g .ct-area {
          fill: hsl(14, 91%, 55%); }

        .ct-series-h .ct-point, .ct-series-h .ct-line, .ct-series-h .ct-bar, .ct-series-h .ct-slice-donut {
          stroke: hsl(14, 83%, 84%); }

        .ct-series-h .ct-slice-pie, .ct-series-h .ct-slice-donut-solid, .ct-series-h .ct-area {
          fill: hsl(14, 83%, 84%); }

        .ct-series-i .ct-point, .ct-series-i .ct-line, .ct-series-i .ct-bar, .ct-series-i .ct-slice-donut {
          stroke: #f05b4f; }

        .ct-series-i .ct-slice-pie, .ct-series-i .ct-slice-donut-solid, .ct-series-i .ct-area {
          fill: #f05b4f; }

        .ct-series-j .ct-point, .ct-series-j .ct-line, .ct-series-j .ct-bar, .ct-series-j .ct-slice-donut {
          stroke: #dda458; }

        .ct-series-j .ct-slice-pie, .ct-series-j .ct-slice-donut-solid, .ct-series-j .ct-area {
          fill: #dda458; }

        .ct-series-k .ct-point, .ct-series-k .ct-line, .ct-series-k .ct-bar, .ct-series-k .ct-slice-donut {
          stroke: #eacf7d; }

        .ct-series-k .ct-slice-pie, .ct-series-k .ct-slice-donut-solid, .ct-series-k .ct-area {
          fill: #eacf7d; }

        .ct-series-l .ct-point, .ct-series-l .ct-line, .ct-series-l .ct-bar, .ct-series-l .ct-slice-donut {
          stroke: #86797d; }

        .ct-series-l .ct-slice-pie, .ct-series-l .ct-slice-donut-solid, .ct-series-l .ct-area {
          fill: #86797d; }
    </style>
        </head>'''

    def cld_mainStart(self):
        return '''<body>
                    <script src="/files/libs/chartist/dist/chartist.min.js"></script>
                    <script src="/files/libs/chartist/chartist-plugin-legend.js"></script>
                    <div class="main-container">'''



    def cld_mainEnd(self):
        return '''
          </div>
          </body>
        </html>'''


    def cld_navigation(self,params):
        activeTrack = 0
        activeGroup = None
        trackInfo = self._result.getTrackInfo()

        # Return Error if trackInfo empty... TODO!!

        if "track" in params:
            activeTrack = params["track"][0]

        if "bgroup" in params:
            activeGroup = params["bgroup"][0]
        else:
            activeGroup = list(trackInfo.keys())[0]

        tracks = trackInfo[activeGroup]
        #tracks = self._result.getTrackNames()
        tracks+=[(0,"Summary")]
        trackName = " "



        outputstr = '''<header class="header-1">
      <div class="branding">
      </div><div class="header-nav">'''

        for bgroup in trackInfo:
            outputstr+='''<a href="/?bgroup='''+bgroup+'''" class="'''
            if bgroup == activeGroup:
                outputstr+="active "
            outputstr+='''nav-link nav-text">'''+bgroup+'''</a>'''

        outputstr+='''</div>
      <div class="header-actions">
          <a href="javascript://" class="nav-link nav-icon" aria-label="settings">
              <clr-icon shape="cog"></clr-icon>
          </a>
      </div>
  </header>
    <nav class="subnav">
        <ul class="nav">'''



        for (tid,tname) in tracks:
            outputstr+='''<li class="nav-item">
                <a class="nav-link'''

            if str(tid) == activeTrack:
                outputstr+=" active"
                trackName = tname

            outputstr+='''" href="/?track='''+str(tid)+'''&bgroup='''+activeGroup+'''">'''+str(tname)+'''</a>
            </li>'''
            
        if trackName == "Summary":
            trackName = "Summary for the whole benchmark set " + activeGroup
        else: 
            trackName = "Overview for " + trackName + " on " + activeGroup


        outputstr+='''</ul></nav><h1 clrfocusonviewinit="" style="padding-left:25px">'''+trackName+'''</h1>'''
        return outputstr

    def _card_title(self,divWrap,divName):
        print(divName,divWrap)
        titleMapping = {"pie" : "Pie chart for", "cactus" : "Cactus plot w/o unknown and errors", "cactus_unk" : "Cactus plot with unknown and errors", "distr" : "Distribution diagramm", "uci" : "Uniquely classified instances"}
        if len(divWrap) > 0:
            divName = divName[0:-len(divWrap)]
        if divName.startswith("pie"):
            divName = "pie"
        return titleMapping[divName]


    def cld_trackPage(self,params):
        # JavaScript Stuff
        jsout = "<script>"
        divWrap = ""
        if "track" in params:
            divWrap = params["track"][0]
        trackInfo = self._result.getTrackInfo()
        if "bgroup" in params:
            activeGroup = params["bgroup"][0]
        else:
            activeGroup = list(trackInfo.keys())[0]



        solvers = self._result.getSolvers()
        names = []
        data = [("distr"+str(divWrap),"Bar",self.generateDistributionGraph(params,"distr"+str(divWrap),activeGroup)),("cactus"+str(divWrap),"Line",self.generateCactusGraph(params,"cactus"+str(divWrap),activeGroup)),("cactus_unk"+str(divWrap),"Line",self.generateCactusGraph(params,"cactus_unk"+str(divWrap),activeGroup,True))]


        print("LOL"+divWrap)

        for s in solvers: 
            data.append(("pie"+str(s)+str(divWrap),"Pie",self.generatePieGraphForSolver(params,"pie"+str(s)+str(divWrap),s,activeGroup)))

        for (divName,diagram,d) in data:
            if diagram == "Pie":
                names+=[(self._card_title(divWrap,divName) +" "+ divName[3:-len(divWrap)],divName)]
            else:
                names+=[(self._card_title(divWrap,divName),divName)]
            for l in d:
                jsout+="var " + l + " = { " + d[l] + " };\n" 
            jsout+="new Chartist."+str(diagram)+"('#"+str(divName)+"', data"+str(divName)+",options"+str(divName)+");\n"
        jsout+="</script>\n\n"

        # html Stuff


        htmlout= '''<div class="content-container"><div class="content-area">'''
        htmlout+=self.getResultsTable(params,activeGroup)
        #htmlout+= self.getUniquelyClassifiedInstances(params)
        htmlout+=self.placeCardUnit([names[0]])
        htmlout+=self.placeCardUnit(names[1:3])
        htmlout+=self.placeCardUnit(names[3:])
        htmlout+="</div></div>"

        return htmlout+jsout


    def placeCardUnit(self,elements):
        outputstr='<div class="clr-row">'
        for (title,divName) in elements:
            outputstr+= '''  <div class="clr-col">
                <div class="card card-block" style="min-width:300px">
                  <h3 class="card-title">''' +str(title) + '''</h3>
                  <div class="ct-chart" id="''' +str(divName) + '''">
                  </div>
                </div>
              </div>\n'''
        outputstr+="</div>"
        return outputstr

    def getUniquelyClassifiedInstances(self,params):
        outputstr='<div class="clr-row"><div class="clr-col"><div class="card card-block" style="min-width:300px"><h3 class="card-title">Uniquely classified instances</h3>'
        avtracks = self._result.getTrackIds()
        for solv in self._result.getSolvers():
            if "track" not in params or int(str(params["track"][0])) not in avtracks:
                data = self._result.getUniquelyClassifiedInstances ()
            else:
                track = int(str(params["track"][0]))
                data = self._result.getUniquelyClassifiedInstancesForTrack(track)

        for solv in data:
            outputstr+="<h4>" + solv + "</h4>"
            outputstr+= '''<table class="table">
                            <thead>
                                <tr>
                                    <th>Instance ID</th>
                                    <th>Result</th>
                                </tr>
                            </thead>
                            <tbody>'''
            for (iid,res) in data[solv]:
                outputstr+='''<tr>
                <td>'''+str(iid)+'''</td>
                <td>'''+str(res)+'''</td>
            </tr>'''
            outputstr+="</tbody></table></div></div></div>"
        return outputstr


    def getResultsTable(self,params,activeGroup):
        outputstr='<div class="clr-row"><div class="clr-col">'

        outputstr+= '''<table class="table">
    <thead>
        <tr>
            <th>Tool name</th>
            <th>Declared satisfiable</th>
            <th>Declared unsatisfiable</th>
            <th>Declared unknown</th>
            <th>Error</th>
            <th>Timeout</th>
            <th>Total instances</th>
            <th>Total time</th>
            <!--<th>Total time w/o Timeout</th>-->
        </tr>
    </thead>
    <tbody>'''


        avtracks = self._result.getTrackIds()
        for solv in self._result.getSolvers():
            if "track" not in params or int(str(params["track"][0])) not in avtracks:
                smtcalls,timeouted,satis,unk,nsatis,errors,time,total = self._result.getSummaryForSolverGroup (solv,activeGroup)
            else:
                track = int(str(params["track"][0]))
                smtcalls,timeouted,satis,unk,nsatis,errors,time,total = self._result.getSummaryForSolverTrack(solv,track)
                   
            outputstr+='''<tr>
                    <td>'''+str(solv)+'''</td>
                    <td>'''+str(satis)+'''</td>
                    <td>'''+str(nsatis)+'''</td>
                    <td>'''+str(unk)+'''</td>
                    <td>'''+str(errors)+'''</td>
                    <td>'''+str(timeouted)+'''</td>
                    <td>'''+str(total)+'''</td>
                    <td>'''+str(time)+'''</td>
                    <!--<td>---</td>-->
                </tr>'''


        outputstr+="</tbody></table></div></div>"
        return outputstr





    def cld_content(self, elements):
        outputstr = '''<div class="content-container">
        <div class="content-area"><div class="clr-row">'''


        avtracks = self._result.getTrackIds()
        for tid in avtracks:
            outputstr+= '''  <div class="clr-col">
                <div class="card card-block" style="min-width:300px">
                  <h3 class="card-title">Track ''' +str(tid) + '''</h3>
                  <div class="ct-chart" id="chart''' +str(tid) + '''">
                  </div>
                </div>
              </div>\n'''

        outputstr+="<script>\n" + self.generateDefaultOptionsJS()
        for tid in avtracks:
             outputstr+=self.generateCactusJSData({"track":str(tid)},"data"+str(tid))
             outputstr+="new Chartist.Line('#chart"+str(tid)+"', data"+str(tid)+",options);"
        outputstr+="</script>"

        outputstr+='''</div>
        </div>
    </div>'''
        return outputstr










