# This file is used to fine tune the benchmarks.

# remove benchmarks with re.reference
# remove benchmarks with bad syntax: e.g. (re.rang "00" "0"), (re.rang "0" "00")
# replace re.+?, re.loop?, re.*?, re.opt? to re.+, re.loop, re.*, re.opt
# replace str.in.re, str.to.re to str.in_re, str.to_re  (smtlib2.6)
# replace \x[0-9a-f]{2,2} to \u{[0-9a-f]{2,2}} (consistent to ostrich)


from runner import RunnerInterface
import argparse, os, re, shutil
from dataclasses import dataclass

dirname = os.path.dirname(__file__)

@dataclass
class Sanitizer(RunnerInterface):
  extension : str = "smt2" 
  
  def run_single_instance(self, filename: str):
    ERR_RE = re.compile(r"(re.range \"[0-9a-zA-Z]{2,}\")|(re.range \".{1}\" \"[0-9a-zA-Z]{2,}\")", re.M)
    try:
      read_f = open(filename, "r", encoding="utf-8")
      file_contents = read_f.read()
      read_f.close()
      removeLazyOperator = file_contents
      # remove lazy operator
      removeLazyOperator = removeLazyOperator.replace("re.+?", "re.+")
      removeLazyOperator = removeLazyOperator.replace("re.loop?", "re.loop")
      removeLazyOperator = removeLazyOperator.replace("re.*?", "re.*")
      removeLazyOperator = removeLazyOperator.replace("re.opt?", "re.opt")
      # consistent to cvc5
      smtlib2020 = removeLazyOperator.replace("str.to.re", "str.to_re")
      smtlib2020 = smtlib2020.replace("str.in.re", "str.in_re")
      ascii2unicode = re.sub(r"\\x([0-9a-f]{2,2})", r"\\u{\1}", smtlib2020, flags=re.M)
      prepend = "(set-logic QF_SLIA)\n(set-option :produce-models true)\n"
      prepended = prepend + ascii2unicode
      (head, benchdirname) = os.path.split(self.benchdir)
      if ERR_RE.search(prepended) or "re.reference" in prepended:
        print(f"{filename} removed")
        return
      newfile =  os.path.join(
        self.outdir, 
        benchdirname,
        os.path.relpath(filename, self.benchdir))
      os.makedirs(os.path.dirname(newfile), exist_ok=True)
      with open(newfile, "w", encoding="utf-8") as wrt_f:
        wrt_f.write(prepended)
    except Exception as e:
      print(f"Open file {filename} wrong: {e}")
      


argparser = argparse.ArgumentParser(
  prog=__file__,
  description='Sanitize benchmarks',
)
argparser.add_argument("bench")
argparser.add_argument("--outdir", default="../benchmarks")

args = argparser.parse_args()
dirname = os.path.dirname(__file__) 
outdir = os.path.join(dirname, args.outdir, 'sanitized')
os.makedirs(outdir, exist_ok=True)
Sanitizer(args.bench, 4, outdir).run()


