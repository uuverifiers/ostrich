#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import tools.ostrichCEA
import utils,storage, summarygenerators
import voting.majority as voting
import models.benchmarks_ca_main_smt2 as ca_bench
import models.not_solved.atl as not_solved_atl_bench
import models.redos_attack_detection as redos_bench
import models.output_tmp as output_bench
import models.all_counting_bench as setta_counting_bench
import models.stringfuzz as stringfuzz_bench
import startwebserver
import tools.ostrichBackend
import tools.cvc5
import tools.regExSolver
import tools.z3seq
import tools.z3str3
import tools.ostrich

tracks = (
    setta_counting_bench.getTrackData() + 
    stringfuzz_bench.getTrackData()
) + []

solvers = {}
for s in [
    tools.regExSolver,
    tools.z3seq,
    tools.z3str3,
    tools.ostrich
]:
    s.addRunner(solvers)

timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("string_fuzz+z3_all")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["Cvc5"]
# verifiers = [""]
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
