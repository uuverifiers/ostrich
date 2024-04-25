#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import tools.ostrichCEA
import utils,storage, summarygenerators
import voting.majority as voting
import models.benchmarks_ca_main_smt2 as ca_bench
import models.not_solved.atl as not_solved_atl_bench
import models.redos_attack_detection as redos_bench
import models.output_tmp as output_bench
import startwebserver
import tools.ostrichBackend
import tools.cvc5

tracks = (
    ca_bench.getTrackData()
) + []

solvers = {}
for s in [
    tools.cvc5,
    tools.ostrichBackend,
]:
    s.addRunner(solvers)

timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("ca_bench+ostrich_unary_all_backend")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["Cvc5"]
# verifiers = [""]
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
