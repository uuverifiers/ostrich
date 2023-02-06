from runner import CVC5Runner
from runner import Z3Runner
import os,argparse
from datetime import datetime


dirname = os.path.dirname(__file__)

# parse arguements
parser = argparse.ArgumentParser(
    prog=__file__, description="Test various backends of ostrich."
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

    
CVC5Runner(args.bench, args.n, outdir).run()