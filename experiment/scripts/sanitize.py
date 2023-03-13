# This file is used to fine tune the benchmarks.

# remove benchmarks with re.reference
# remove benchmarks with bad syntax: e.g. (re.rang "00" "0"), (re.rang "0" "00")
# replace re.+?, re.loop?, re.*?, re.opt? to re.+, re.loop, re.*, re.opt
# replace str.in.re, str.to.re to str.in_re, str.to_re  (smtlib2.6)
# replace \x[0-9a-f]{2,2} to \u{[0-9a-f]{2,2}} (consistent to ostrich)


from runner import RunnerInterface
import argparse, os, re
from dataclasses import dataclass

dirname = os.path.dirname(__file__)

@dataclass
class Sanitizer(RunnerInterface):
  extension : str = "smt2" 
  outdir: str = ""
  
  def run_single_instance(self, filename: str):
    ERR_RE = re.compile(r"(re.range \"[0-9a-zA-Z\\]{2,}\")|(re.range \".{1}\" \"[0-9a-zA-Z\\]{2,}\")", re.M)
    try:
      readf= open(filename, "r", encoding="utf-8")
      file_contents = readf.read()
      readf.close()
      # remove lazy operator
      removeLazyOperator = file_contents.replace("re.+?", "re.+")
      removeLazyOperator = removeLazyOperator.replace("re.loop?", "re.loop")
      removeLazyOperator = removeLazyOperator.replace("re.*?", "re.*")
      removeLazyOperator = removeLazyOperator.replace("re.opt?", "re.opt")
      # consistent to cvc5
      smtlib2020 = removeLazyOperator.replace("str.to.re", "str.to_re")
      smtlib2020 = smtlib2020.replace("str.in.re", "str.in_re")
      ascii2unicode = re.sub(r"\\x([0-9a-f]{2,2})", r"\\u{\1}", smtlib2020, flags=re.M)
      if ERR_RE.search(ascii2unicode) or "re.reference" in ascii2unicode:
        print(f"{filename} removed")
        os.remove(filename)
        return
      writef = open(filename, "w", encoding="utf-8")
      writef.write(ascii2unicode)
      writef.close()
    except Exception as e:
      print(f"Sanitize file {filename} wrong: {e}")

argparser = argparse.ArgumentParser(
  prog=__file__,
  description='Sanitize benchmarks',
)
argparser.add_argument("bench")

args = argparser.parse_args()
Sanitizer(args.bench, 4).run()


