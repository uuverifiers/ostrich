from multiprocessing.dummy import Pool
import os
import glob
import subprocess
from datetime import datetime
from unittest import result
from tqdm import tqdm
from time import time 


dirname = os.path.dirname(__file__)
timelimit = 60
command = os.path.join(dirname, "../../ostrich")


class Runner:
    backend: str
    benchname: str
    proccess_num: int
    outdir: str
    
    def __init__(self, backend: str, benchname: str, n: int, outdir: str) -> None:
        self.backend = backend
        self.benchname = benchname
        self.proccess_num = n
        self.outdir = outdir

    def write_results(self, results: list[str]):
        with open(os.path.join(self.outdir, f"{self.backend}_log.txt"), "w") as f:
            for result in results:
                f.write(f"{result}{os.linesep}")
                f.flush()

    def run_single_instance(self, benchmark: str):
        str_result = []
        str_result.append(f"Running [{benchmark}]")
        pbar.set_description(f"Running [{benchmark}]")
        now_time = last_time = time() * 1000
        try:
            res = subprocess.run(
                [
                    command,
                    "+costenriched",
                    "+minimizeAutomata",
                    f"-backend={self.backend}",
                    "+incremental",
                    "-inputFormat=smtlib",
                    benchmark,
                ],
                timeout=timelimit,
                capture_output=True,
                encoding="utf-8",
            )
            str_result.append(res.stdout)
        except subprocess.TimeoutExpired:
            str_result.append(f"Timeout ")
        now_time = time() * 1000
        str_result.append(f"Time: {now_time - last_time} ms")
        str_result.append(f"----splitter----")
        pbar.update(1)
        return os.linesep.join(str_result)

    def run(self):
        benchname = self.benchname
        benchmarks = glob.glob(f"{benchname}/**/*.smt2", recursive=True)
        global pbar
        pbar = tqdm(total = len(benchmarks))
        with Pool(processes=self.proccess_num) as pool:
            results = pool.imap_unordered(
                self.run_single_instance,
                benchmarks,
                chunksize = int(len(benchmarks)/self.proccess_num)
            )
            self.write_results(results)
        pbar.close()


# run benchmark concurrent, the processes number is 4
# from multiprocessing import Pool
# def runScript(runner):
#     runner.run()
# while True:
#     with Pool(processes=4) as pool:  # start 4 worker processes
#         pool.map(runScript, runners)
#     time.sleep(100)
