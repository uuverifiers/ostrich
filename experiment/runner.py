from distutils.cmd import Command
import os
import glob
import subprocess
from datetime import datetime
from click import command
from tqdm import tqdm
from tqdm.contrib import DummyTqdmFile
import sys
from multiprocessing import Pool
import time

dirname = os.path.dirname(__file__)
timelimit = 60
command = os.path.join(dirname, "../ostrich")


class Runner:
    backend: str
    benchname: str

    def __init__(self, backend: str, benchname: str):
        self.backend = backend
        self.benchname = benchname

    def run(self):
        benchname = self.benchname
        backend = self.backend

        # list to store files
        benchmarks = tqdm(glob.glob(f"{benchname}/**/*.smt2", recursive=True))
        now = datetime.now()
        format = "%y-%m-%d_%H_%M_%S_%f"
        date = now.strftime(format)
        filename = os.path.join(benchname, f"{date}_{backend}_log.txt")

        with open(filename, "w") as f:
            for benchmark in benchmarks:
                f.write(f"Running [{benchmark}]{os.linesep}")
                try:
                    res = subprocess.run(
                        [
                            command,
                            "+costenriched",
                            "+minimizeAutomata",
                            f"-backend={backend}",
                            "+incremental",
                            "-inputFormat=smtlib",
                            benchmark,
                        ],
                        timeout=timelimit,
                        capture_output=True,
                        encoding="utf-8"
                    )
                    f.write(res.stdout)
                except subprocess.TimeoutExpired:
                    f.write(f"Timeout {os.linesep}")
                f.write(f"----splitter----{os.linesep}")


benchmarks = os.path.join(dirname, "benchmarks")
backends = ["baseline", "catra", "unary"]
runners = [Runner(backend, benchmarks) for backend in backends]


def runScript(runner):
    runner.run()


# while True:
#     with Pool(processes=4) as pool:  # start 4 worker processes
#         pool.map(runScript, runners)
#     time.sleep(100)

for runner in runners:
    runner.run()
