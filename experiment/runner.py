from distutils.cmd import Command
import os
import glob
import subprocess
from datetime import datetime
from tqdm import tqdm
from tqdm.contrib import DummyTqdmFile
import sys
from multiprocessing import Pool
import time

dirname = os.path.dirname(__file__)

class Runner:
  backend: str
  benchname: str

  def __init__(self, backend: str, benchname: str):
    self.backend = backend
    self.benchname = benchname
  
  def run(self):
    benchname = self.benchname
    command = os.path.join(dirname, "../ostrich")
    backend = self.backend

    # list to store files
    benchmarks = tqdm(glob.glob(f"{benchname}/**/*.smt2", recursive=True), dynamic_ncols=True)
    now = datetime.now()
    format = "%d_%m_%y_%H_%M_%S_%f"
    date = now.strftime(format)
    filename = os.path.join(benchname, f"{date}_{backend}_log.txt")
    command = os.path.join(benchname, "../../ostrich")

    for benchmark in benchmarks:
        subprocess.run([f"echo Runing [{benchmark}] >> {filename}"], shell=True)
        subprocess.run([f"{command} -stringSolver=ostrich.OstrichStringTheory:+costenriched,+minimizeAutomata,-backend={backend} +incremental -inputFormat=smtlib -timeout=60000 {benchmark} >> {filename}"], shell=True, stderr=DummyTqdmFile(sys.stderr))
        subprocess.run([f"echo ----splitter---- >> {filename}"], shell=True)

benchmarks = os.path.join(dirname, "benchmarks")
backends = ["baseline", "catra", "unary"]
runners = [Runner(backend, benchmarks) for backend in backends]

# for runner in runners:
#   runner.run()

def runScript(runner):
  runner.run()


while True:
    with Pool(processes=4) as pool:  # start 4 worker processes
        pool.map(runScript, runners)
    time.sleep(100)
