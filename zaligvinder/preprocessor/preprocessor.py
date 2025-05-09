import os 
import tempfile
import shutil
import re
import sys
from os.path import *
import subprocess

class Preprocessor:
    def __init__(self,ploc,solverName,parameters):
        self._timeout = 20
        self._path = ploc.findProgram (solverName)
        if not self._path:
            raise f"{solverName} not in path!"
        self._parameters = parameters

    def __call__(self,eq,output_file,store_instance=False):
        tempd = tempfile.mkdtemp ()
        smtfile = os.path.join (tempd,"out.smt")
        self.prepare_instance(eq,smtfile)
        data = self.runTool(smtfile)
        self.writeFile(data,output_file)
        shutil.rmtree (tempd)
        if store_instance:
            self.storeInstance(eq,output_file)
    
    def _translate_smt26_escape_to_smt25(self,text):
        smtLibKeyWords = {"2.6" : ["re.comp","str.from_int", "str.to_int","str.in_re","str.to_re","re.none"],
                          "2.5" : ["re.complement","int.to.str", "str.to.int","str.in.re","str.to.re","re.nostr"]}
        
        for i,exp in enumerate(smtLibKeyWords["2.6"]):
            text = re.sub(exp,smtLibKeyWords["2.5"][i],text)

        return re.sub('u{(..)}', r'x\1', re.sub('u{(.)}', r'x0\1', text))

    def prepare_instance(self,eq,tmpfile):
        setLogicPresent = False
        #set logic present?
        with open(eq) as flc:
            for l in flc:
                if not l.startswith(";") and '(set-logic' in l:
                    setLogicPresent = True
        
        f=open(eq,"r")
        copy=open(tmpfile,"w")
        if not setLogicPresent:
            copy.write("(set-logic ALL)\n")

        for l in f:
            if "(set-logic" in l:
                l = re.sub('\(set-logic.*?\)', '(set-logic ALL)', l)
            for exp in ["\(get-model\)","\(check-sat\)","\(exit\)"]:
                l = re.sub(exp, '', l)

            if not l.startswith(";"):
                copy.write(l)

        copy.write("\n(check-sat)")
        f.close()
        copy.close() 
        return None

    def writeFile(self,data,output_file):
        f=open(output_file,"w")
        for l in data:
                f.write(self._translate_smt26_escape_to_smt25(l))
        f.write("\n(check-sat)")
        f.close()

    def runTool(self,inputFile):
        try:
            out = subprocess.check_output([self._path]+self._parameters+[inputFile],timeout=self._timeout).decode().strip()
        except subprocess.CalledProcessError as e:
            return [f"{s}\n" for s in str(e.output)[2:-1].split("\\n") if not s.startswith("unknown") and not s.startswith("(error") and not s.startswith("(check-sat)") and not s.startswith("(get-model)") and not s.startswith("(set-option")]
        return [f"{s}\n" for s in out.split("\n") if not s.startswith("unknown") and not s.startswith("(error") and not s.startswith("(check-sat)") and not s.startswith("(get-model)") and not s.startswith("(set-option")]
    

    def storeInstance(self,eq,output_file,prefix="preprocessed"):
        eq_data = eq.split("/")
        thisSet = eq_data[-3]
        thisTrack = eq_data[-2]
        thisInstance = eq_data[-1]
        thisModelPath = eq[:-(len(thisSet)+len(thisTrack)+len(thisInstance)+3)]
        thisPath = thisModelPath+"/"+prefix+"/"+thisSet+"/"+thisTrack
        try:
            os.makedirs(thisPath,exist_ok=True)
        except:
            pass
        shutil.copyfile(output_file,thisPath+"/"+thisInstance)
