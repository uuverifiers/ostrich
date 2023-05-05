#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.automatark
import models.redos
import models.regexlib
import models.stackoverflow
import models.tmp
import startwebserver

import tools.ostrichBackend


import summarygenerators

tracks = (
            # models.automatark.getTrackData() +
            # models.redos.getTrackData() +
            # models.regexlib.getTrackData() +
            # models.stackoverflow.getTrackData()
            models.tmp.getTrackData()
         + [])
# tracks = testbench.getTrackData() + []
solvers = {}
for s in [
    tools.ostrichBackend,
]:
    s.addRunner(solvers)

summaries = [summarygenerators.terminalResult]
timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("backend-compare-allBench")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["ostrich-unary"]

testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
