#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.automatark_len_9
import models.generated_len_9
import startwebserver

import tools.ostrichHeuristics


import summarygenerators

tracks = (
    models.automatark_len_9.getTrackData() + 
    models.generated_len_9.getTrackData()
) + []
solvers = {}
for s in [
    tools.ostrichHeuristics,
]:
    s.addRunner(solvers)

summaries = [summarygenerators.terminalResult]
timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("ATVA2023-heuristic-allBench")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["ostrich-all"]

testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
