#!/usr/bin/python

from runners.multi import TheRunner as testrunner
import utils
import storage
import voting.majority as voting

import models.RegExBenchmarks_sml
import models.stringfuzzregextransformed_sml
import models.stringfuzzregexgenerated_sml
import models.automatark_sml
import startwebserver

import experiment.zaligvinder.tools.cvc5
import tools.z3str3
import tools.regExSolverHeuristics
import tools.ostrich
import tools.z3seq
import tools.trau


import summarygenerators
tracks = (models.automatark_sml.getTrackData("AutomatArk Preview")+
          models.stringfuzzregexgenerated_sml.getTrackData("StringFuzz-regex-generated Preview")+
          models.stringfuzzregextransformed_sml.getTrackData("StringFuzz-regex-transformed Preview")+
          models.RegExBenchmarks_sml.getTrackData("RegEx Collected Preview") +
        []
        )

solvers = {}
for s in [tools.cvc5,
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
