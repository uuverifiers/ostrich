#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.RegExBenchmarks
import models.stringfuzzregextransformed
import models.stringfuzzregexgenerated
import models.automatark
import startwebserver

import tools.cvc4
import tools.z3str3
import tools.regExSolverHeuristics
import tools.ostrich
import tools.z3seq
import tools.trau


import summarygenerators
tracks = (models.automatark.getTrackData()+
          models.stringfuzzregexgenerated.getTrackData()+
          models.stringfuzzregextransformed.getTrackData()+
          models.RegExBenchmarks.getTrackData("RegEx Collected") +
        []
        )

solvers = {}
for s in [tools.cvc4,
          tools.ostrich,
          tools.z3seq,
          tools.z3str3,
          tools.regExSolverHeuristics,
          tools.trau,
]:
    s.addRunner (solvers)

summaries = [summarygenerators.terminalResult
]
timeout = 20 
ploc = utils.JSONProgramConfig ()

store = storage.SQLiteDB ("CAV21")
summaries = [
    summarygenerators.terminalResult,
    store.postTrackUpdate
]
verifiers = ["cvc4","z3seq"]
testrunner().runTestSetup (tracks,solvers,voting.MajorityVoter(),summaries,store,timeout,ploc,verifiers)
startwebserver.Server (store.getDB ()).startServer ()
