import subprocess
import tempfile
import os
import shutil
import utils
import sys
import timer


def run(eq, timeout, ploc, wd):
    path = ploc.findProgram("OSTRICH2")
    if not path:
        raise "OSTRICH2 Not in Path"

    (fd, smtfile) = tempfile.mkstemp(suffix=".smt2")

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
                    "+quiet",
                    "+incremental",
                    "-inputFormat=smtlib",
                    "-portfolio=strings",
                    "-timeout=" + str(timeout) + "000",
                ] + [smtfile],
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
    if "unsat" in out:
        return utils.Result(False, time.getTime_ms(), False, 1, out)
    elif "sat" in out:
        return utils.Result(
            True, time.getTime_ms(), False, 1, out, "\n".join(
                out.split("\n")[1:])
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
     addto["OSTRICH2"] = run


if __name__ == "__main__":
    print(run(sys.argv[1], None))
