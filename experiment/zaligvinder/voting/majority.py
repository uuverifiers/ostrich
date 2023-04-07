import os 
import tempfile
import shutil
import re
import sys
from functools import reduce

class MajorityVoter:
    def voteOnResult (self,track,res,verifiers=[]):
        name,instances = track.name,track.instances
        print(res.keys())
        for i,inst in enumerate(instances):
            if inst.expected == None:
                toolResults = [res[solver][i] for solver in res.keys() if (solver in verifiers or len(verifiers) == 0)]
                print(toolResults)
                
                satVerified = False
                if len(verifiers) > 0:
                    verifiedResults = [r.verified for r in toolResults if r.result == True]
                    if len(verifiedResults) > 0:
                        satVerified = reduce((lambda x, y: x or y), verifiedResults)

                tts = [r for r in toolResults if r.result == True]
                ffs = [r for r in toolResults if r.result == False]
                unk = [r for r in toolResults if r.result == None]
                ctts = len(tts)
                cffs = len(ffs)
                cunk = len(unk)
                if ctts > 0 or cffs > 0:
                    #Someone made a conclusion
                    if ctts > cffs or satVerified:
                        #More True votes or at least on verified answer
                        inst.expected = True
                        
                    elif cffs > ctts:
                        #More False votes
                        inst.expected = False
