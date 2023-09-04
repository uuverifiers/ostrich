import subprocess
import tempfile
import os
import shutil
import sys
import timer
import utils
import re

# path = shutil.which ("cvc4")
# path = utils.findProgram ("CVC4BINARY","cvc4")


def run(eq, timeout, ploc, wd, solver="1", param="60"):
    path = ploc.findProgram("Cvc5")
    if not path:
        raise "cvc5 Not in Path"
    (fd, smtfile) = tempfile.mkstemp(suffix=".smt2")

    setLogicPresent = False
    # set logic present?
    with open(eq) as flc:
        for l in flc:
            if not l.startswith(";") and "(set-logic" in l:
                setLogicPresent = True

    # hack to insert (get-model), which is needed for cvc5 to output a model
    f = open(eq, "r")
    copy = open(smtfile, "w")
    firstLine = None

    if not setLogicPresent:
        copy.write("(set-logic QF_ALL)\n")

    for l in f:
        if not l.startswith(";") and firstLine == None:
            firstLine = True

        if firstLine:
            firstLine = False

        # if "(get-model)" not in l and "(check-sat)" not in l and "(exit)" not in l:
        for exp in ["\(get-model\)", "\(check-sat\)", "\(exit\)"]:
            l = re.sub(exp, "", l)

        if "(set-logic" in l:
            l = re.sub("\(set-logic.*?\)", "(set-logic QF_ALL)", l)
        # str.in.re to str.in_re, str.to.re to str.to_re
        l = l.replace("str.in.re", "str.in_re")
        l = l.replace("str.to.re", "str.to_re")
        copy.write(l)

    copy.write("\n(check-sat)")
    f.close()
    copy.close()

    time = timer.Timer()
    try:
        out = (
            subprocess.check_output(
                [
                    path,
                    "--incremental",
                    "--lang=smt2",
                    "--strings-exp",
                    "--dump-models",
                    "--tlimit-per",
                    str(timeout) + "000",
                    smtfile,
                ],
                timeout=int(timeout),
            )
            .decode()
            .strip()
        )
    except subprocess.TimeoutExpired:
        return utils.Result(None, timeout * 1000, True, 1)
    except subprocess.CalledProcessError as e:
        time.stop()

        if time.getTime() >= timeout:
            return utils.Result(None, time.getTime_ms(), True, 1)
        else:
            out = "Error in " + eq + ": " + str(e.output)
            return utils.Result(None, time.getTime_ms(), False, 1, out)
    finally:
        os.unlink(smtfile)
    time.stop()
    if "unsat" in out:
        return utils.Result(False, time.getTime_ms(), False, 1, out)
    elif "sat" in out:
        return utils.Result(
            True, time.getTime_ms(), False, 1, out, "\n".join(out.split("\n")[1:])
        )
    elif time.getTime() >= timeout:
        return utils.Result(None, time.getTime_ms(), True, 1)
    elif "unknown" in out:
        return utils.Result(None, time.getTime_ms(), False, 1, out)
    else:
        # must be an error
        return utils.Result(
            None, time.getTime_ms(), False, 1, f"Error in {eq} # stdout: {out}"
        )


def addRunner(addto):
    # addto['CVC4-18'] = run
    addto["Cvc5"] = run


if __name__ == "__main__":
    print(run(sys.argv[1], None))
