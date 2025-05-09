import os 
import tempfile
import shutil
import re
import sys


# import all tools
from tools import *

class Verifier:
    def _extractAssignment(self,model):
        s = ""
        for l in model:
            s+=l.rstrip("\n")

        return s[len("(model"):-1]

    def _translateSMTFile(self,filepath):
        f=open(filepath,"r")
        matchingBraces = 0
        firstMatchFound = False
        currentWord = ""
        in_qutation = False
        previous_char = None
        for l in f:
            if l.startswith(";"):
                continue
            for a in l:
                if a == "(" and not in_qutation:
                    matchingBraces+=1
                    firstMatchFound = True
                if a == ")" and not in_qutation:
                    matchingBraces-=1

                if firstMatchFound == True:
                    if a == '"' and not previous_char == '\\':
                        in_qutation = not in_qutation
                    previous_char = a
                    currentWord+=a

                if matchingBraces == 0 and len(currentWord) > 0 and firstMatchFound:
                    yield currentWord
                    currentWord = ""
        f.close()

    def _modifyInputFile(self,tempd,model,filepath):
        smtfile = os.path.join (tempd,"out.smt")
        copy=open(smtfile,"w")
        firstLine = None
        declareBlockReached = False
        for l in self._translateSMTFile(filepath):
            if not l.startswith(";") and firstLine == None:
                firstLine = True

            # set (set-logic ALL) if no logic was set
            if "(set-logic" not in l and firstLine:
                copy.write("(set-logic ALL)\n")    
            
            if firstLine:
                firstLine = False

            if "(define-fun" in l or "(declare-fun" in l: 
                if declareBlockReached == False:
                    declareBlockReached = True   
            elif declareBlockReached == True:
                copy.write("\n"+model+"\n")
                declareBlockReached = None
            elif "(get-model)" not in l:
                copy.write(l+"\n")

        copy.write("\n(get-model)")
        copy.close()
        return smtfile

    def getSolver(self,solvername):
        import importlib
        if os.path.exists("tools/"+solvername+".py"):
            full_module_name = "tools." + solvername
            thisSolver = importlib.import_module(full_module_name)
            return thisSolver
        return None

    def verifyModel (self,res,ploc,filepath,timeout=0,verifiers=dict()):
        assert(res.result == True)
        verifierCount = len(verifiers)
        if verifierCount > 0:
            vRes = None
            foundModel = self._extractAssignment(res.model)
            tempd = tempfile.mkdtemp ()
            assertedInputFile = self._modifyInputFile(tempd,foundModel,filepath)
            for vn in verifiers:
                v = self.getSolver(vn)
                if v == None:
                    continue
                thisRes = v.run(assertedInputFile,timeout,ploc,os.path.abspath(".")).result
                
                # work arround if we verified the model at least once
                if (thisRes == True and vRes == None) or (thisRes == None and vRes == True):
                    vRes = True
                elif (thisRes == False and vRes == None) or (thisRes == None and vRes == False):
                    vRes = False
                else:
                    vRes = vRes and thisRes
            res.verified = vRes
            shutil.rmtree (tempd)
        return res
