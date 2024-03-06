#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils,storage, summarygenerators
import voting.majority as voting
import models.benchmarks_ca_main_smt2 as ca_bench
import startwebserver
import tools.ostrichBackend
import tools.cvc5

tracks = (
    ca_bench.getTrackData()
) + []

solvers = {}
for s in [
    tools.ostrichBackend,
    tools.cvc5
]:
    s.addRunner(solvers)

timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("ca_bench-ostrich_unary")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["Cvc5"]
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
