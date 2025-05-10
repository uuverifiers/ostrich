#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils,storage, summarygenerators
import voting.majority as voting
import startwebserver
import os
# tools
import tools.cvc5
import tools.ostrich1
import tools.ostrich2
import tools.ostrich2_rcp
import tools.z3noodler
import tools.z3alpha
import tools.z3
import tools.ostrich2_cea_adt
# benchmarks
from models import fmcad

tracks = (
    fmcad.getTrackData()
) + []

solvers = {}
for s in [
    tools.cvc5,
    tools.z3,
    tools.z3alpha,
    tools.z3noodler,
    tools.ostrich1,
    tools.ostrich2,
    tools.ostrich2_cea_adt,
    tools.ostrich2_rcp
]:
    s.addRunner(solvers)

timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("fmcad")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = [""]
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)

# We need to kill any running instances of Z3alpha
# since Z3alpha has a bug that causes it to hang
z3alpha_cmd = ploc.findProgram("Z3alpha")
z3alpha_dir = os.path.dirname(os.path.abspath(z3alpha_cmd))
os.system(f"pkill -f '^{z3alpha_dir}'")

startwebserver.Server(store.getDB()).startServer()
