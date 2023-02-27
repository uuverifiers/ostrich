import npyscreen
import storage

class SelectDB:
    def __init__(self,path):
        self._dirpath = path
    def start (self,*args):
        import os
        dir_path = self._dirpath
        filest = []
        for root, dirs, files in os.walk(dir_path, topdown=False):
            for name in files:
                if name.endswith (".db"):
                    filest.append(os.path.join (root,name))
        F = npyscreen.Form(name='Select DB')
        tt = F.add(npyscreen.TitleSelectOne, 
               name='Database file',
               values = filest,
               scroll_exit = True  # Let the user move out of the widget by pressing the down arrow instead of tab.  Try it without
                                                    # to see the difference.
    )

        
        F.edit()
        self.db = storage.sqlitedb.DB (tt.values[tt.value[0]])


