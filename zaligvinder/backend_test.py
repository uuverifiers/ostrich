#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils,storage, summarygenerators
import voting.majority as voting
import models.benchmarks_ca_main_smt2 as ca_bench
import models.not_solved as not_solved_bench
import models.redos_attack_detection as redos_bench
import startwebserver
import tools.ostrichBackend
import tools.cvc5

tracks = (
    redos_bench.getTrackData()
) + []

solvers = {}
for s in [
    tools.cvc5,
]:
    s.addRunner(solvers)

timeout = 1
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("redos_bench+cvc5")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
# verifiers = ["Cvc5"]
verifiers = [""]
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
