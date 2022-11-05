import os
import sys
import argparse
from runner import Runner
from datetime import datetime

dirname = os.path.dirname(__file__)


class ArgParser:
    parser: argparse.ArgumentParser

    def __init__(self) -> None:
        self.parser = argparse.ArgumentParser(
            prog="backend_test.py",
            description="This script is used to run benchmark automatically",
        )

        self.parser.add_argument(
            "--backends",
            nargs="*",
            default=["baseline", "catra", "unary"],
            help="set the backend to test",
            metavar="backend1,",
            choices=["baseline", "catra", "unary"],
        )
        
        self.parser.add_argument(
            "--suffix",
            default="",
            help="set the suffix of output directory name",
            metavar="suffix",
            type=str,
        )
        
        self.parser.add_argument(
            "-n",
            default=1,
            help="set the number of process to run",
            metavar="n",
            type=int,
        )
        
        self.parser.add_argument("bench")
            
        
    def parse_args(self):
        self.parser.parse_args(sys.argv[1:], namespace=self)     
    

argparser = ArgParser()
argparser.parse_args()
benchmarks = argparser.bench
print(benchmarks)
backends = argparser.backends
# out directory name
date = datetime.now().strftime("%y-%m-%d_%H:%M:%S")
outdir = os.path.join(dirname, f"../res/{date}{argparser.suffix}")
os.makedirs(outdir, exist_ok=True)

runners = [Runner(backend=backend, benchname=benchmarks, n = argparser.n, outdir=outdir) for backend in backends]
for runner in runners:
    runner.run()