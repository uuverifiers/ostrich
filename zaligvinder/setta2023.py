#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import startwebserver
import models.test
import models.generated
import models.automatark_len


import tools.regExSolver
import tools.z3str3
import tools.z3seq
import tools.cvc5
import tools.ostrich
import tools.ostrichCEA
import tools.ostrichBackend


import summarygenerators

tracks = (
    models.generated.getTrackData() +
    models.automatark_len.getTrackData()
) + []

solvers = {}
for s in [
    tools.cvc5,
    tools.regExSolver,
    tools.z3str3,
    tools.z3seq,
    tools.ostrich,
    tools.ostrichCEA,
    tools.ostrichBackend
]:
    s.addRunner(solvers)

summaries = [summarygenerators.terminalResult]
timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("setta2023")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["Cvc5"]
testrunner(4).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
