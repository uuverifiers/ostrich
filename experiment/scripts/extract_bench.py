import sys, re, argparse, os, shutil
from datetime import datetime

def parse_single_result(result: str) -> None:
    UNKNOWN_RE = re.compile("^unknown|^--Unknown", re.M)
    ERR_RE = re.compile("^\(error (?!\"no model available\")|^--Exception", re.M | re.I)
    TIMEOUT_RE = re.compile("^Timeout", re.M)
    SAT_RE = re.compile("^sat", re.M)
    INSTANCE_RE = re.compile("^Running \[(.*)\]", re.M)
    
    instance = INSTANCE_RE.search(result).group(1)

    if "unknown" in args.extract and UNKNOWN_RE.search(result):
        extract_files["unknown"].append(instance)
    if "timeout" in args.extract and TIMEOUT_RE.search(result):
        extract_files["timeout"].append(instance)
    if "error" in args.extract and ERR_RE.search(result):
        extract_files["error"].append(instance)
    if "sat" in args.extract and SAT_RE.search(result):
        extract_files["sat"].append(instance)


# parse argument
argparser = argparse.ArgumentParser(
    prog=__file__,
    description="Extract benchmark of specific types from the log file. The types is a list and can be unknown, timeout or error",
)
argparser.add_argument(
    "--extract",
    nargs="*",
    default=["unknown", "timeout", "error", "sat"],
    help="The types",
    choices=["unknown", "timeout", "error", "sat"],
)
argparser.add_argument("--suffix", default="", help="The suffix of the directory")
argparser.add_argument("filename")
args = argparser.parse_args()
dirname = os.path.dirname(__file__)


extract_files = {}
date = datetime.now().strftime("%y-%m-%d_%H:%M:%S")
extract_dir = os.path.join(dirname, f"../extracted/{date}{args.suffix}")
for feature in args.extract:
    feature_dir = os.path.join(extract_dir, feature)
    os.makedirs(feature_dir, exist_ok=True)
    extract_files[feature] = []

with open(args.filename, "r", encoding="utf8") as f:
    results = f.read().split("----splitter----")
    for result in results[:-1]:
        parse_single_result(result)

for feature in extract_files.keys():
    feature_dir = os.path.join(extract_dir, feature)
    for instance in extract_files[feature]:
        shutil.copy(
            os.path.join(dirname, "../", instance),
            feature_dir,
        )
