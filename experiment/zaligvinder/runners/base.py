#!/usr/bin/python3
import os
import sys
import utils
import tools.cvc4
import tools.z3seq

def progressMessage (track,file,solver,cur,total):
    sys.stdout.write ("\x1b[2K\r[ {0}  {1} {2} - {3}/{4}]".format(track,file,solver,cur+1,total))

class TheRunner:
    def runTrack (self,track,solvers,store,timeout,ploc):
        print (track)
        results = {}
        tname, files = track.name, track.instances
        print ("Running track {0} with {1} files.".format (tname,len(files)))
    
        for solver,func in solvers.items():
            for i,n in enumerate(files):
                progressMessage (tname,n.name,solver,i,len(files))
                result = func (n.filepath,timeout,ploc,os.path.abspath("."))
                store.writeData (track,n,solver,result)
                results[solver] = results.get(solver,[]) + [result]
        sys.stdout.write ("\n")
        return results

    def runTestSetup (self,tracks,solvers,voter,summaries,outputfile,timeout,ploc,verifiers=dict()):
        for t in tracks:
            res = self.runTrack (t,solvers,outputfile,timeout,ploc)
            voter.voteOnResult (t,res,timeout,ploc,verifiers)
            for s in summaries:
                s(t,res)
