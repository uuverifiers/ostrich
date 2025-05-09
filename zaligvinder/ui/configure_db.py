import npyscreen
import storage

class ConfigureTableGeneration:
    def __init__(self,res,track):
        self._res = res
        self._track = track
        self._techniques = ["LaTeX - Tables (total)","LaTeX - Tables (benchmark groups)","LaTeX - Cactus Plot (total)","LaTeX - Cactus Plot (benchmark groups)","ASCIIDoctor page"]
    
    def start (self,*args):
        groups = [tup[0] for tup in list(self._track.getAllGroups ())]
        solvers =self._res.getSolvers () 
        F = npyscreen.Form(name='Configure Table Generation')
        outputloc = F.add(npyscreen.TitleText, 
               name='Output to'
        )
        
        G = npyscreen.Form(name='Select Benchmarks Groups')
        selgroup = G.add(npyscreen.MultiSelect, 
               name='Select Benchmark Groups',
               values = groups,
               scroll_exit = True  # Let the user move out of the widget by pressing the down arrow instead of tab.  Try it without
         #to see the difference.
        )
        
        H = npyscreen.Form(name='Select Solvers')
        
        selsolv = H.add(npyscreen.MultiSelect, 
               name='Solvers',
               values = solvers,
               scroll_exit = True  # Let the user move out of the widget by pressing the down arrow instead of tab.  Try it without
                                                    # to see the difference.
        )

        I = npyscreen.Form(name='Select Output Format')
        
        seltable = I.add(npyscreen.TitleSelectOne, 
               name='Table Technique',
               values = self._techniques,
               scroll_exit = True  # Let the user move out of the widget by pressing the down arrow instead of tab.  Try it without
                                                    # to see the difference.
        )
        
        
        F.edit ()
        G.edit ()
        H.edit ()
        I.edit ()
        self.groups = [selgroup.values[i] for i in selgroup.value]
        self.solvers = [selsolv.values[i] for i in selsolv.value]
        self.tableStyle = [seltable.values[i] for i in seltable.value][0]
        self.loc = outputloc.value
        
        #self.db = storage.sqlitedb.DB (tt.values[tt.value[0]])

