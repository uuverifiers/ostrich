import webserver.views.TextView
import webserver.views.charts.charts as charts
import random


class BaseView(webserver.views.TextView.TextView):
    def __init__ (self):
        super().__init__()
        
    def header (self,sendto):
        sendto.send_header ('Content-type','text/html')
        sendto.end_headers ()

    def response_code (self,sendto):
        sendto.send_response (200)

    def writeTop (self,sendto):
        top = '''<!DOCTYPE html>
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

       .ct-label.ct-horizontal.ct-end {
       text-align:center; display:inline; position:relative;
       font-size: 10px !important;
       writing-mode:vertical-rl; 
       transform:  translateX(-0%) translateY(-666%);
     }


#chart svg {
  overflow: visible;
}

      '''

        #colors = [ "#0065AB" ,"#007E7A", "#A6D8E7", "#CD3517","#FF8142","#85C81A","#1D5100","#8939AD","#4D007A","#00D4B8","#25333D","#007E7A","#0F1E82","#4E56B8","#798893","#49AFD9",]
        colors = ["#25333D","#0065AB","#8939AD","#007E7A","#CD3517","#318700","#80746D","#FF9A69","#00D4B8","#85C81A", #none_5_z3str3
                  "#AC75C6","#0F1E82","#A3EDF6","#FFB38F","#49AFD9",]

        # extend the colors 
        r = lambda: random.randint(0,255)
        colorGen = lambda : '#%02X%02X%02X' % (r(),r(),r())
        while len(colors) < 26:
          newColor = colorGen()
          if newColor not in colors:
            colors+=[newColor]

        for i,c in enumerate(colors):
          top+='''.ct-legend .ct-series-'''+str(i)+''':before {
                     background-color: '''+c+''';
                     border-color: '''+c+''';
                 }'''
          nextChar = chr(ord('a') + i)
          top+='''.ct-series-'''+nextChar+''' .ct-point, .ct-series-'''+nextChar+''' .ct-line, .ct-series-'''+nextChar+''' .ct-bar, .ct-series-'''+nextChar+''' .ct-slice-donut {
            stroke: '''+c+'''; }

          .ct-series-'''+nextChar+''' .ct-slice-pie, .ct-series-'''+nextChar+''' .ct-slice-donut-solid, .ct-series-'''+nextChar+''' .ct-area {
            fill: '''+c+'''; }'''


        top+='''
        [class^=".badge.badge-"], .badge[class*=" badge-"] {
            background:#FAFAFA; 
            color: #737373;
        }


        .badge,.badge.badge-1 {
          background: #ffdc0B;
          color: #313131;
        }

        .badge,.badge.badge-2 {
          background: #A9B6BE;
        }

        .badge,.badge.badge-3 {
          background: #C47D00;
        }

        .error_row {
          background:#F5DBD9;color:#A32100;padding:5px;    
        }
        .verify_row {
          background:#FEECB5;color:#EFD603;padding:5px; 
        }

        .unique_row {
          background:#DFF0D0;color:#266900;padding:5px;
        }
        .unknown_row {
            background:#E1F1F6;color:#004A70;padding:5px;
        } 
        .ambiguous_row {
            background:#FEECB5;color:#EFD603;padding:5px;
        } 

        .hide_div {
          display:none;
        }





    </style>
        </head>'''
        sendto.write (bytes(top,"utf8"))

    
    def send_content (self,sendto):
        pass
        
    def message (self,sendto):
        self.writeTop (sendto)
        sendto.write (bytes('''<body onload="getTableData();" >''',"utf8"))
        sendto.write (bytes(f'''<script src="/files/libs/chartist/dist/chartist.min.js"></script>
        <script src="/files/libs/chartist/chartist-plugin-legend.js"></script>
        <script src="/files/js/helper.js"></script> 
        <script src="/files/js/chartist-to-image/chartist-to-image.js"></script>

        <div class="main-container">''',"utf8"))
        self.send_content (sendto)
        sendto.write (bytes("</div></body></html>","utf8"))

    def genNavigation (self,sendto,active):
        sendto.write (bytes('''
    <header class="header-1">
        <div class="branding"> <span class="nav-text nav-link" style="font-size:18px;"><clr-icon shape="shield-check" style="font-size:22px; color:#00968B;"></clr-icon>ZaligVinder</span>
      </div><div class="header-nav" [clr-nav-level]="1">''','utf8'))
        sendto.write (bytes(
            "\n".join (['''<a href="{}" class="{} nav-link nav-text">{}</a>'''.format (tup[1],tup[2],tup[0]) for tup in [("Getting Started","/",active[0]),("Benchmark Summary","/becnhmarks/",active[1]),("Tool Comparison","/comparison/",active[2])]]),
            "utf8"))
        sendto.write (bytes("</div></header>","utf8"))
        

class BenchmarkTrackView(BaseView):
    def __init__(self,
                 benchmarks,
                 tracks,
                 benchmark,
                 trackname,
                 ctrackid,
                 solvers = []
    ):
        
        self._bmarks = benchmarks
        self._curBenchmark = benchmark
        self._tracks = tracks
        self._ctrack = trackname
        self._ctrackid = ctrackid
        self._table = charts.OverviewTable (["/summary/{}/{}?bgroup={}".format(s,ctrackid,benchmark) for s in solvers])
        self._rankingTable = charts.RankingTable ("/ranks/"+format(ctrackid)+"/?bgroup="+format(benchmark))
        
        self._distribution = charts.Distribution ("/chart/distribution/{}?bgroup={}".format(ctrackid,benchmark))
        self._pie = charts.Pie ("/chart/distribution/{}?bgroup={}".format(ctrackid,benchmark))
        self._cactusunk = charts.Cactus ("Cactus with Unknown and Errors",
                                         "/chart/cactus?track={}&bgroup={}".format(ctrackid,benchmark),
                                         "cactus_unk"
        )
        self._cactusnunk = charts.Cactus ("Cactus without Unknown and Errors",
                                         "/chart/cactus?track={}&bgroup={}&nounk=tt".format(ctrackid,benchmark),
                                         "cactus_nunk"
        )

    def genSideNavigation(self,sendto):
        sendto.write (bytes('''
        <nav class="sidenav" [clr-nav-level]="2">
          <section class="sidenav-content">''',"utf8"))

        for i,(bgroup,link) in enumerate(self._bmarks):
            active = ""
            if bgroup == self._curBenchmark and None == self._ctrack:
              active="active"

            sendto.write (bytes('''<section class="nav-group collapsible">
            <input id="tab'''+str(i)+'''" type="checkbox">
            <label for="tab'''+str(i)+'''">'''+str(bgroup)+'''</label>
            <ul class="nav-list">''',
            "utf8"))
            
            for (bname,link) in self._tracks[bgroup]:
              active = ""
              if bgroup == self._curBenchmark and bname == self._ctrack:
                active="active"
              sendto.write (bytes('''<li><a class="nav-link '''+active+'''" href="'''+str(link)+'''">'''+str(bname)+'''</a></li>''',"utf8"))
            sendto.write (bytes('''</ul></section>''',"utf8"))
        sendto.write (bytes('''</section></nav>''',"utf8"))

    def genOverviewTable (self,sendto):
        sendto.write (bytes(self._table.html(),"utf8"))        


    def genRankingTable (self,sendto):
        sendto.write (bytes(self._rankingTable.html(),"utf8"))   

    def genJavascript (self):
        return "".join ([self._table.javascript (),
                         self._rankingTable.javascript(),
                         self._distribution.javascript (),
                         self._pie.javascript (),
                         #self._cactusunk.javascript (),
                         self._cactusnunk.javascript (),
                         
        ])
        
        
    def send_content (self,sendto):
        top3 = '''
        <script>
        function getTableData () {
          addSolversToOverViewTable ();
          addRankingTable();
          setupDistChart ();
          setupPieChart ();
          //setupCactuscactus_unk ();
          setupCactuscactus_nunk ();
        }</script>'''
        sendto.write (bytes(top3,"utf8"))
        sendto.write (bytes(self.genJavascript (),"utf8"))
        self.genNavigation (sendto,["","active",""])
        sendto.write (bytes('''<div class="content-container"><div class="content-area">''',"utf8"))
        if self._ctrack != None:
          sendto.write (bytes('''<h1 clrfocusonviewinit="" style="padding-left:25px">Overview for {} on {}</h1>'''.format (self._ctrack,self._curBenchmark),"utf8"))
        else:
          sendto.write (bytes('''<h1 clrfocusonviewinit="" style="padding-left:25px">Summary data for {}</h1>'''.format (self._curBenchmark),"utf8"))
        

        self.genOverviewTable (sendto)

        self.genRankingTable (sendto)
        sendto.write (bytes(self._distribution.html(),"utf8"))
        sendto.write (bytes(self._pie.html(),"utf8"))
        #sendto.write (bytes(self._cactusunk.html(),"utf8"))
        sendto.write (bytes(self._cactusnunk.html(),"utf8"))
        sendto.write (bytes('''</div>''',"utf8"))
        self.genSideNavigation (sendto)
        sendto.write (bytes('''</div></div>''',"utf8"))

class BenchmarkComparisonView(BaseView):
    def __init__(self,
                 benchmarks,
                 tracks,
                 benchmark,
                 trackname,
                 ctrackid,
                 activeSolvers = [],
                 solvers = [],
                 instances = []
    ):
        
        self._bmarks = benchmarks
        self._curBenchmark = benchmark
        self._tracks = tracks
        self._ctrack = trackname
        self._ctrackid = ctrackid
        self._solverUrl= '&'.join("solvers="+str(s) for s in activeSolvers)
        #self._table = charts.ComparisonTable (["../instances/solvers/{}/?{}".format(i,solverUrl) for i in instances],activeSolvers,solvers,{"bgroup": benchmark, "trackid": ctrackid})
        self._table = charts.ComparisonTable (["/instances/solvers/{}/?{}".format(i,self._solverUrl) for i in instances],activeSolvers,solvers,{"bgroup": benchmark, "trackid": ctrackid})

    def genSideNavigation(self,sendto):
        sendto.write (bytes('''
        <nav class="sidenav" [clr-nav-level]="2">
          <section class="sidenav-content">''',"utf8"))

        for i,(bgroup,link) in enumerate(self._bmarks):
            active = ""
            if bgroup == self._curBenchmark and None == self._ctrack:
              active="active"

            sendto.write (bytes('''<section class="nav-group collapsible">
            <input id="tab'''+str(i)+'''" type="checkbox">
            <label for="tab'''+str(i)+'''">'''+str(bgroup)+'''</label>
            <ul class="nav-list">''',
            "utf8"))
            
            for (bname,link) in self._tracks[bgroup]:
              active = ""
              if bgroup == self._curBenchmark and bname == self._ctrack:
                active="active"
              sendto.write (bytes('''<li><a class="nav-link '''+active+'''" href="'''+str(link)+'''&'''+self._solverUrl+'''">'''+str(bname)+'''</a></li>''',"utf8"))
            sendto.write (bytes('''</ul></section>''',"utf8"))
        sendto.write (bytes('''</section></nav>''',"utf8"))

    def genOverviewTable (self,sendto):
        sendto.write (bytes(self._table.html(),"utf8"))        



    def genJavascript (self):
        return "".join ([self._table.javascript (),                                        
        ])
        
        
    def send_content (self,sendto):
        top3 = '''
        <script>
        function getTableData () {
          addInstaceToComparisonTable();
        }</script>'''
        sendto.write (bytes(top3,"utf8"))
        sendto.write (bytes(self.genJavascript (),"utf8"))
        self.genNavigation (sendto,["","","active"])
        sendto.write (bytes('''<div class="content-container"><div class="content-area">''',"utf8"))
        if self._ctrack != None:
          sendto.write (bytes('''<h1 clrfocusonviewinit="" style="padding-left:25px">Overview for {} on {}</h1>'''.format (self._ctrack,self._curBenchmark),"utf8"))
        else:
          sendto.write (bytes('''<h1 clrfocusonviewinit="" style="padding-left:25px">Summary data for {}</h1>'''.format (self._curBenchmark),"utf8"))
        

        self.genOverviewTable (sendto)
        sendto.write (bytes('''</div>''',"utf8"))
        self.genSideNavigation (sendto)
        sendto.write (bytes('''</div></div>''',"utf8"))


class EntryView(BaseView):
    def __init__(self,
                 benchmarks,
                 tracks,
                 solvers = [],
                 instanceCount = 0
    ):
        
        self._bmarks = benchmarks
        self._tracks = tracks
        self._solvers = solvers
        self._totalInstances = instanceCount
        
    def genEntryText(self,sendto):
      tt = '''<div class="clr-row clr-justify-content-centerr">
                <div class="clr-col-4">                
                <div class="card">
                       <div class="card-header">
                          Welcome
                      </div>
                        <div class="card-block">
                            <p class="card-text">'''
      tt+="Your current setup features "+str(len(self._solvers))+" solvers on "+str(len(self._tracks))+" tracks in "+str(len(self._bmarks))+" benchmark sets, having "+ str(self._totalInstances)+" many instances."


      tt+='''
                            </p>
                        </div>
                    </div>
                </div>
            </div>'''

      tt+= '''<div class="clr-row clr-justify-content-centerr">
                <div class="clr-col">                
                <div class="card">
                       <div class="card-header">
                          A short guide for ZaligVinder.
                      </div>
                        <div class="card-block">
                            <p class="card-text">

                              On the upper end of this web app you can choose between three categories which will be explained briefly here

<ol class="list">
<li><h3>Getting Started.</h3>
This is the current page. It shows you nothing more than this small guide.
</li>

<li><h3>Benchmark Summary.</h3>
This pages prints you a useful summary for all of your benchmark sets and tracks.

The sub navigation on the right hand side allows you to choose a specific track or the summary for a whole set of benchmarks. You may have to scroll down to view other tracks.



Each page offers you an overview table of grouped instances.

The table holds the tool name, how many instances are declared as satisfiable resp. unsatisfiable, unknown instances (the solver terminates without a result before getting killed by the timeout limit), misclassification of an instance (error - currently done by a majority vote between all results of the solvers), timed out instances, the total amount within a track/set of benchmarks, and the overall solving time.

The second table shows a ranking of each solver participating on a track. The grading is easily modifiable and currently is done as follows: 

<ol class="list">
<li>Instance declared correctly: solver count / position of the solver within all correctly classified solvers</li>
  The fastest correctly classifying solver gets most of the points.</li>
<li>Unknown declared instance before time out kills the solver: +1 Point.</li>
<li>Timeout: -1 Point.</li>
<li> Error: - solver count Points.</li></ol>

The first diagram shows a distribution for each solver distinguishing between satisfiable/unsatisfiable and timed out resp. unknown instances.

The next set of diagrams show the same distribution as before as a pie diagram. This makes an easier identification possible in some cases.

A cactus diagram follows. In these kind of plots all instances are sorted by their solving time and listed ascending as a point within a line diagram. The first cactus plot lists all instances of a track / benchmark set. It gives an intuition of how quick a solver classifies all instances over time. The structure of a cactus plot automatically holds all timed out instances in the end. 

Excluding the unknowns an errors gives an intuition of how quick a solver comes up with the correct answers.

By clicking on a label of the graph, the user is able to active/deactivate a specific solver.
</li>
<li><h3>Tool Comparison</h3>
This page offers you the opportunity to compare different solvers per instances; finding out what instances caused a good or a bad behaviour. 

The navigation between different tracks and benchmark summaries is again done using the side navigation as explained previously.

The top box allows you to choose between the available solvers by clicking on a label. Solvers highlighted in green are part of the current comparison. You can disable them by simply clicking the x. White labelled solvers are not part of the comparison. Active them again by a click.

The comparison table holds the following elements:
<ol class="list">
<li>The instance name - corresponding to the input file. Click on the file icon to view the instance.</li>
<li>For each solver (listed in the first row of the table):
<ol class="list"><li>A Result classified by an icon. <clr-icon shape="check"></clr-icon> means the solver classified the instance as satisfiable, <clr-icon shape="times"></clr-icon> unsatisfiable and <clr-icon shape="unknown-status"></clr-icon> as unknown or timed out.</li>
<li>Time to solve the instance</li>
<li>The model. If a model is available click on the icon <clr-icon shape="list"></clr-icon>. The absense of a model is indicated by <clr-icon shape="no-access"></clr-icon>. Whenever a solver terminated unexpectedly we indicate this behaviour by <clr-icon shape="error-standard" class="is-solid"></clr-icon>. Click on the icon to view the solvers output.
</li></ol>
</li></ol>
The filter icon on the right hand side gives you the following options:
<ol class="list">
<li> Show unique classfied instances, that is if there is only on solver within the current view which classified the instance. The corresponding solver is marked by <clr-icon shape="check-circle" class="is-solid"></clr-icon> resp. <clr-icon shape="times-circle" class="is-solid">.</li>

<li>Show instances with errors, where only wrongly classified instances given the technique are displayed. The column of the wrong solver is marked again with <clr-icon shape="check-circle" class="is-solid"></clr-icon> resp. <clr-icon shape="times-circle" class="is-solid"></clr-icon></li>

<li>Show undeclared instances lists all instances where no solver found a solution.</li>

<li>Show only instances, where the solver terminated unexpectedly.</li>

<li>Only ambiguous answers is showing only instances where an error classification was not possible. This could for instance happen if we do not know the correct answer of an instance and the solvers are not agreeing.</li>
</li></ol>





                            </p>
                        </div>
                    </div>
                </div>
            </div>'''





            

      sendto.write (bytes(tt,"utf8"))

        
    def send_content (self,sendto):
        self.genNavigation (sendto,["active","",""])
        sendto.write (bytes('''<div class="content-container"><div class="content-area">''',"utf8"))
        sendto.write (bytes('''<h1 clrfocusonviewinit="" style="padding-left:25px">Hi!</h1>''',"utf8"))

        self.genEntryText (sendto)
        sendto.write (bytes('''</div>''',"utf8"))
        #self.genSideNavigation (sendto)
        sendto.write (bytes('''</div></div>''',"utf8"))

