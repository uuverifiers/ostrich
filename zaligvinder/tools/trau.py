import subprocess
import tempfile
import os
import shutil
import utils
import sys
import timer


#path = utils.findProgram ("Z3BINARY","z3")

def run (eq,timeout,ploc,wd):
    path = ploc.findProgram ("Trau")
    if not path:
        raise "Trau Not in Path"

    tempd = tempfile.mkdtemp ()
    smtfile = os.path.join (tempd,"out_trau.smt")
    #tools.woorpje2smt.run (eq,smtfile,ploc)


    # hack to get rid of (get-model), not needed for z3 and returns 1 / Error if input is unsat
    f=open(eq,"r")
    copy=open(smtfile,"w")
    for l in f:
        if "(get-model)" not in l:
            # substitute str.to_re to str.to.re, str.in_re to str.in.re
            l = l.replace("str.to_re", "str.to.re")
            l = l.replace("str.in_re", "str.in.re")
            copy.write(l)
    
    f.close()
    copy.close() 



    time = timer.Timer ()
    try:
        out = subprocess.check_output ([path,"smt.string_solver=trau","dump_models=true",smtfile],timeout=timeout).decode().strip()
    except subprocess.TimeoutExpired:
        return utils.Result(None,timeout*1000,True,1)
    except subprocess.CalledProcessError as e:
        time.stop()
        out = "Error in " + eq + ": " + str(e)
        return utils.Result(None,time.getTime_ms(),False,1,out)

    time.stop()    

    if "NOT IMPLEMENTED YET!" in out and not time >= timeout:
        out = "Error in " + eq + ": " + out    
        
    shutil.rmtree (tempd)
    if "unsat" in out:
        return utils.Result(False,time.getTime_ms (),False,1,out)
    elif "sat" in out:
        return utils.Result(True,time.getTime_ms(),False,1,out,"\n".join(out.split("\n")[1:]))
    elif time.getTime() >= timeout:
        return utils.Result(None,timeout*1000,True,1)
    elif "unknown" in out:
        return utils.Result(None,time.getTime_ms  (),False,1,out)
    else:
        # must be an error
        return utils.Result(None,time.getTime_ms (), False,1,f"Error in {eq} # stdout: {out}")




def addRunner (addto):
    addto['Z3Trau'] = run


if __name__ == "__main__":
    print(run (sys.argv[1],None))

