#!/usr/bin/env python3

import sys
import os
import subprocess

logic_strategy = {
    "BV": "bv900.txt",
    "UFDT": "ufdt900.txt",
    "QF_BV": "qfbv900.txt",
    "QF_DT": "qfdt900.txt",
    "QF_UFDT": "qfufdt900.txt",
    "QF_AUFBV": "qfaufbv900.txt",
    "QF_UFBV": "qfufbv900.txt",
    "QF_AX": "qfax900.txt",
    "QF_UF": "qfuf900.txt",
    "QF_IDL": "qfidl900.txt",
    "QF_LIA": "qflia900.txt",
    "QF_LRA": "qflra900.txt",
    "QF_RDL": "qfrdl900.txt",
    "QF_NIA": "qfnia900.txt",
    "QF_NRA": "qfnra900.txt",
    "QF_S": "qfs900.txt",
    "QF_SLIA": "qfslia900.txt"
}

def read_smtlib_logic(smt2_str):
    for line in smt2_str.split('\n'):
        if line.startswith('(set-logic'):
            return line.split()[1][:-1]
    return None

def rewrite_smt2_with_strat(smt2_str, strat):
    new_smt2_str = ""
    for line in smt2_str.split('\n'):
        if "check-sat" in line:
            new_smt2_str += f"(check-sat-using {strat})\n"
        else:
            new_smt2_str += line + "\n"
    return new_smt2_str

def main():
    script_path = os.path.realpath(__file__)
    z3alpha_dir = os.path.dirname(script_path)
    if len(sys.argv) != 2:
        print(f"Usage: {script_path} <smt2_path>")
        return
    
    smt2_path = sys.argv[1]
    with open(smt2_path, 'r') as f:
        smt2_str = f.read()

    solver_path = os.path.join(z3alpha_dir, "z3bin", "z3")

    logic = read_smtlib_logic(smt2_str)
    if logic in ["QF_S", "QF_SLIA", "QF_SNIA"]:
        solver_path = os.path.join(z3alpha_dir, "z3bin", "z3str")

    if logic and (logic in logic_strategy):
        strat_filename = logic_strategy[logic]
        strat_path = os.path.join(z3alpha_dir, "strats", strat_filename)
        # check whether strat_path exists
        if os.path.exists(strat_path):
            with open(strat_path, 'r') as f:
                strat = f.read()
            smt2_str = rewrite_smt2_with_strat(smt2_str, strat)

    # write into a new smt2 file in tmp
    new_smt2_path = "/tmp/rw_instance.smt2"
    with open(new_smt2_path, 'w') as f:
        f.write(smt2_str)

    # run z3 with the new smt2 file
    cmd = f"{solver_path} {new_smt2_path}"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

    # Print the standard output and standard error
    print(result.stdout, end="")

if __name__ == "__main__":
    main()