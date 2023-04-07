#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.automatark as automark
import models.redos as redos
import models.regexlib as regexlib
import models.stackoverflow as stackoverflow

import startwebserver

import tools.z3str3
import tools.regExSolver
import tools.ostrichCEA
import tools.ostrich
import tools.z3seq
import tools.trau
import tools.cvc5


import summarygenerators

tracks = (automark.getTrackData() + 
          redos.getTrackData() + 
          regexlib.getTrackData() +
          stackoverflow.getTrackData()
          ) + []

solvers = {}
for s in [
    tools.cvc5,
    tools.ostrichCEA,
    tools.ostrich,
    tools.z3str3,
    tools.z3seq,
    tools.regExSolver,
    tools.trau
]:
    s.addRunner(solvers)

summaries = [summarygenerators.terminalResult]
timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("ATVA2023-allSolver-allBench")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["Cvc5", "Z3str3RE", "ostrichCEA"]
# verifiers = []
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
