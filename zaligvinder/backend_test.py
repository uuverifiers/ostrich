#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.PyEx_All as pyex
import models.test as test

import startwebserver

import tools.ostrichBackend
import tools.cvc5
import tools.ostrich

import summarygenerators

tracks = (
    pyex.getTrackData()
) + []

solvers = {}
for s in [
    tools.cvc5,
    tools.ostrichBackend,
    tools.ostrich
]:
    s.addRunner(solvers)

summaries = [summarygenerators.terminalResult]
timeout = 60
ploc = utils.JSONProgramConfig()

store = storage.SQLiteDB("backend_test")
summaries = [summarygenerators.terminalResult, store.postTrackUpdate]
verifiers = ["Cvc5"]
testrunner(12).runTestSetup(
    tracks, solvers, voting.MajorityVoter(), summaries, store, timeout, ploc, verifiers
)
startwebserver.Server(store.getDB()).startServer()
