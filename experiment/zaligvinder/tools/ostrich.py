import subprocess
import tempfile
import os
import shutil
import utils
import sys
import timer


def run(eq, timeout, ploc, wd):
    path = ploc.findProgram("Ostrich")
    if not path:
        raise "Ostrich Not in Path"

    tempd = tempfile.mkdtemp()
    smtfile = os.path.join(tempd, "out.smt")

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
                [
                    path,
                    "-logo",
                    "-length=on",
                    "+quiet",
                    "-inputFormat=smtlib",
                    "+model",
                    "-timeout=" + str(timeout) + "000",
                    smtfile,
                ],
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

    time.stop()
    shutil.rmtree(tempd)
    if "unsat" in out:
        return utils.Result(False, time.getTime_ms(), False, 1, out)
    elif "sat" in out:
        return utils.Result(
            True, time.getTime_ms(), False, 1, out, "\n".join(out.split("\n")[1:])
        )
    elif time.getTime() >= timeout:
        return utils.Result(None, timeout * 1000, True, 1)
    elif "unknown" in out:
        return utils.Result(None, time.getTime_ms(), False, 1, out)
    else:
        # must be an error
        return utils.Result(
            None, time.getTime_ms(), False, 1, f"Error in {eq} # stdout: {out}"
        )


def addRunner(addto):
    addto["ostrich"] = run


if __name__ == "__main__":
    print(run(sys.argv[1], None))
