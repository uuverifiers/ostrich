from runner import RunnerInterface
import os, re
import shutil
import argparse
from dataclasses import dataclass


def analyze(filename: str):
    with open(filename, "r", encoding="utf-8") as f:
        content = f.read()
        LOOP_RE = re.compile(r"\(_ re.loop \d+ (\d+)\)", re.MULTILINE)
        STR_TO_INT_RE = re.compile(r"\(str.to.int\)|\(int.to.str\)", re.MULTILINE)
        countsum = 0
        for count in LOOP_RE.findall(content):
            countsum += int(count)
        return (countsum > 50, countsum > 0, STR_TO_INT_RE.match(content) is not None)


@dataclass
class ExtractSmtWithCount(RunnerInterface):
    extension: str = ".smt2"

    def run_single_instance(self, filename: str):
        largedir = os.path.join(self.outdir, "large")
        smalldir = os.path.join(self.outdir, "small")
        os.makedirs(largedir, exist_ok=True)
        os.makedirs(smalldir, exist_ok=True)
        (islarge, haveloop, have_str_to_int) = analyze(filename)
        basename = os.path.basename(filename)
        if have_str_to_int:
            return
        if islarge:
            shutil.copyfile(filename, os.path.join(largedir, basename))
        elif haveloop:
            shutil.copyfile(filename, os.path.join(smalldir, basename))


# parse arguments
parser = argparse.ArgumentParser(
    prog=__file__, description="Extract smt2 files with count."
)
parser.add_argument("inputdir")
parser.add_argument("-outdir", default="../benchmarks/count_benchmark_others")
args = parser.parse_args()
dirname = os.path.dirname(__file__)
outdir = os.path.join(dirname, args.outdir)
os.makedirs(outdir, exist_ok=True)

ExtractSmtWithCount(args.inputdir, 1, outdir).run()
