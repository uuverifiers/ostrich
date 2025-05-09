import subprocess
import tempfile
import os
import shutil
import sys

# Get the parent directory of the current script
parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

# Add the parent directory to the Python path so it can find utils.py
sys.path.append(parent_dir)

# Now you can import utils
import utils
import timer




def run(eq, timeout, ploc, wd):
    path = ploc.findProgram("Z3noodler")
    if not path:
        raise "Z3noodler Not in Path"

    (fd, smtfile) = tempfile.mkstemp(suffix=".smt2")
    # tools.woorpje2smt.run (eq,smtfile,ploc)

    # hack to get rid of (get-model), not needed for z3 and returns 1 / Error if input is unsat
    f = open(eq, "r")
    copy = open(smtfile, "w")
    for l in f:
        if "(get-model)" not in l:
            copy.write(l)

    f.close()
    copy.close()

    time = timer.Timer()
    try:
        out = (
            subprocess.check_output(
                [path, "model=true", smtfile],
                timeout=timeout,
            )
            .decode()
            .strip()
        )
    except subprocess.TimeoutExpired:
        return utils.Result(None, timeout * 1000, True, 1)
    except subprocess.CalledProcessError as e:
        time.stop()
        out = "Error in " + eq + ": " + str(e)
        return utils.Result(None, time.getTime_ms(), False, 1, out)
    finally:
        os.unlink(smtfile)
    time.stop()

    if "NOT IMPLEMENTED YET!" in out and not time >= timeout:
        out = "Error in " + eq + ": " + out
    if "unsat" in out:
        return utils.Result(False, time.getTime_ms(), False, 1, out)
    elif "sat" in out:
        return utils.Result(
            True, time.getTime_ms(), False, 1, out, "\n".join(
                out.split("\n")[1:])
        )
    elif time.getTime() >= timeout:
        return utils.Result(None, timeout * 1000, True, 1)
    return utils.Result(None, time.getTime_ms(), False, 1, out)


def addRunner(addto):
    addto["Z3noodler"] = run


if __name__ == "__main__":
    print(run(sys.argv[1], None, utils.JSONProgramConfig(), None).output)
