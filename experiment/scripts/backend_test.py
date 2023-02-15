import os
import sys
import argparse
from runner import BaseLineRunner, CatraRunner, UnaryRunner
from datetime import datetime

dirname = os.path.dirname(__file__)

# parse arguements
parser = argparse.ArgumentParser(
    prog=__file__, description="Test various backends of ostrich."
)
parser.add_argument(
    "--backend",
    help="the backends to run",
    choices=["baseline", "catra", "unary"],
)
parser.add_argument(
    "--suffix",
    default="",
    help="the suffix of output directory name",
    type=str,
)
parser.add_argument(
    "-n",
    default=1,
    help="the number of process running benchmarks",
    type=int,
)
parser.add_argument("bench")
args = parser.parse_args()
# out directory name
date = datetime.now().strftime("%y-%m-%d_%H:%M:%S")
outdir = os.path.join(dirname, f"../res/{date}{args.suffix}")
os.makedirs(outdir, exist_ok=True)

# run the benchmark by different backend
if (args.backend == "baseline"):
    BaseLineRunner(args.bench, args.n, outdir).run()
elif (args.backend == "catra"):
    CatraRunner(args.bench, args.n, outdir).run()
else:
    UnaryRunner(args.bench, args.n, outdir).run()