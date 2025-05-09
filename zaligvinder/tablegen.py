import os
import ntpath
import ui
import latex.summ_table
import latex.summ_table_woorpje
import latex.summ_table_all
import latex.cactus
import markdown.summ_table
import markdown.markdown
import storage
from datetime import date 

uii =  ui.SelectDB (os.path.dirname(os.path.realpath(__file__)))
ui.init (uii)
db = uii.db
trackinstance = storage.sqlitedb.TrackInstanceRepository (db)
track = storage.sqlitedb.TrackRepository(db,trackinstance)
results = storage.sqlitedb.ResultRepository (db,track,trackinstance)

finalui = ui.ConfigureTableGeneration (results,track)
ui.init (finalui)


print (finalui.groups,finalui.solvers,finalui.loc,finalui.tableStyle)

if finalui.tableStyle == "ASCIIDoctor page":
	table = markdown.markdown.MarkdownGenerator (results,track,finalui.solvers,finalui.groups) #markdown.summ_table.TableGenerator (results,track,finalui.solvers,finalui.groups)
elif finalui.tableStyle == "LaTeX - Cactus Plot (total)":
	table = latex.cactus.CactusGenerator (results,track,finalui.solvers,finalui.groups,True)
elif finalui.tableStyle == "LaTeX - Cactus Plot (benchmark groups)":
	table = latex.cactus.CactusGenerator (results,track,finalui.solvers,finalui.groups,False)
elif finalui.tableStyle == "LaTeX - Tables (total)":
	table = latex.summ_table_all.TableGenerator (results,track,finalui.solvers,finalui.groups,True)
else:
	table = latex.summ_table_all.TableGenerator (results,track,finalui.solvers,finalui.groups,False)
	#table = latex.summ_table_woorpje.TableGenerator (results,track,finalui.solvers,finalui.groups)

# set filename if empty
if len(finalui.loc) == 0:
	finalui.loc = f"external_data/{date.today().strftime('%Y%m%d')}/index.txt"

# create dir if needed
fileName = ntpath.basename(finalui.loc)
path = finalui.loc[:-len(fileName)][:-1]
if fileName != finalui.loc:
	os.makedirs(f'{path}', exist_ok=True)

with open(finalui.loc,'w') as f:
	table.generateTable (f)
