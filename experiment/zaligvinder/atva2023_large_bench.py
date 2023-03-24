#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.automatark.large as automark_large
import models.redos.large as redos_large
import models.regexlib.large as regexlib_large
import models.stackoverflow.large as stackoverflow_large

import startwebserver

import tools.z3str3
import tools.regExSolver
import tools.ostrichCEA
import tools.ostrich
import tools.z3seq
import tools.trau
import tools.cvc5


import summarygenerators

tracks = (automark_large.getTrackData() + 
          redos_large.getTrackData() + 
          regexlib_large.getTrackData() +
          stackoverflow_large.getTrackData()
          ) + []

solvers = {}
for s in [
    tools.cvc5,
    tools.ostrichCEA,
    tools.ostrich,
    tools.z3str3,
    tools.z3seq,
    tools.regExSolver,
]:
    s.addRunner(solvers)

summaries = [summarygenerators.terminalResult]
timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("ATVA2023-allsolver-large")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["cvc5", "z3seq", "ostrichCEA"]
# verifiers = []
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
