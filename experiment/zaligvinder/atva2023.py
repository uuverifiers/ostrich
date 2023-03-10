#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.regexlib.small as testbench
import startwebserver

import tools.z3str3
import tools.regExSolver
import tools.ostrich
import tools.z3seq
import tools.trau
import tools.cvc5


import summarygenerators

tracks = testbench.getTrackData() + []

solvers = {}
for s in [
    tools.cvc5,
    tools.ostrich,
    tools.z3str3,
    tools.z3seq,
    tools.regExSolver,
    # tools.trau,   // tran can not deal with re.diff
]:
    s.addRunner(solvers)

summaries = [summarygenerators.terminalResult]
timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("ATVA2023")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["cvc5", "z3seq"]
# verifiers = []
testrunner(20).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
