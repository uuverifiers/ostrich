import sys, re, argparse, os, shutil
from datetime import datetime


class ArgParser:
    parser: argparse.ArgumentParser

    def __init__(self) -> None:
        self.parser = argparse.ArgumentParser(
            prog="backend_test.py",
            description="This script is used to run benchmark automatically",
        )

        self.parser.add_argument(
            "--extract",
            nargs="*",
            default=["unknown", "timeout", "error"],
            help="extract benchmark of specific types from the log file. The types is a list and can be unknown, timeout or error",
            metavar="error type1,",
            choices=["unknown", "timeout", "error"],
        )

        self.parser.add_argument("filename")

    def parse_args(self):
        self.parser.parse_args(sys.argv[1:], namespace=self)


def parse_single_result(result: str) -> None:
    UNKNOWN_RE = re.compile("^unknown|^--Unknown", re.M)
    ERR_RE = re.compile("^\(error |^--Exception", re.M | re.I)
    INSTANCE_RE = re.compile("^Running \[(.*)\]", re.M)
    TIMEOUT_RE = re.compile("^Timeout", re.M)
    instance = INSTANCE_RE.search(result).group(1)

    if "unknown" in argparser.extract and UNKNOWN_RE.search(result):
        extract_files["unknown"].append(instance)
    elif "timeout" in argparser.extract and TIMEOUT_RE.search(result):
        extract_files["timeout"].append(instance)
    elif "error" in argparser.extract and ERR_RE.search(result):
        extract_files["error"].append(instance)


dirname = os.path.dirname(__file__)
argparser = ArgParser()
argparser.parse_args()


extract_files = {}
date = datetime.now().strftime("%y-%m-%d_%H:%M:%S")
extract_dir = os.path.join(dirname, f"../extracted/{date}")
for feature in argparser.extract:
    feature_dir = os.path.join(extract_dir, feature)
    os.makedirs(feature_dir, exist_ok=True)
    extract_files[feature] = []

with open(argparser.filename, "r", encoding="utf8") as f:
    results = f.read().split("----splitter----")
    for result in results[:-1]:
        parse_single_result(result)

for feature in extract_files.keys():
    feature_dir = os.path.join(extract_dir, feature)
    for instance in extract_files[feature]:
        shutil.copy(
            os.path.join(dirname, "../../", instance),
            feature_dir,
        )
