#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils,storage,argparse, summarygenerators
import voting.majority as voting
import models.test as test
import models.all_counting_bench as counting_bench
import startwebserver
import tools.ostrichBackend
import tools.cvc5

tracks = (
    counting_bench.getTrackData()
) + []

solvers = {}
for s in [
    tools.ostrichBackend,
    tools.cvc5
]:
    s.addRunner(solvers)

timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("counting-ostrich_unary")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["Cvc5"]
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
