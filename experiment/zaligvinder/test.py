#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.tmp.tmp as test_bench

import startwebserver

import tools.z3str3
import tools.regExSolver
import tools.ostrichCEA
import tools.ostrich
import tools.z3seq
import tools.trau
import tools.cvc5


import summarygenerators

tracks = (test_bench.getTrackData() 
          ) + []

solvers = {}
for s in [
    tools.cvc5,
    tools.ostrich,
    tools.regExSolver,
]:
    s.addRunner(solvers)

summaries = [summarygenerators.terminalResult]
timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("test")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["Cvc5", "Z3str3RE", "ostrichCEA"]
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
