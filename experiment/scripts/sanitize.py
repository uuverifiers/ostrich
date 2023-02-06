# remove benchmarks with re.reference
# remove benchmarks with re.+?, re.loop?, re.*?

from runner import RunnerInterface
import argparse, os, shutil, re
from dataclasses import dataclass

@dataclass
class Sanitizer(RunnerInterface):
  extension : str = "smt2" 
  
  def run_single_instance(self, filename: str):
    ERR_RE = re.compile(r"re.range \"[^ ]{3}", re.M)
    try:
      read_f = open(filename, "r", encoding="utf-8")
      file_contents = read_f.read()
      read_f.close()
      removeLazyOperator = file_contents
      if "re.+?" in file_contents:
        removeLazyOperator = removeLazyOperator.replace("re.+?", "re.+")
      if "re.loop?" in file_contents:
        removeLazyOperator = removeLazyOperator.replace("re.loop?", "re.loop")
      if "re.*?" in file_contents:
        removeLazyOperator = removeLazyOperator.replace("re.*?", "re.*")
      if ERR_RE.search(file_contents) or "re.reference" in file_contents:
        return f"{filename} removed"
      with open(filename, "w", encoding="utf-8") as wrt_f:
        wrt_f.write(removeLazyOperator)
      newfile =  os.path.join(self.outdir, os.path.relpath(filename, self.benchdir))
      os.makedirs(os.path.dirname(newfile), exist_ok=True)
      shutil.copy(filename, newfile)
    except:
      print("An exception occurred when read file")
      


argparser = argparse.ArgumentParser(
  prog=__file__,
  description='Sanitize benchmarks',
)
argparser.add_argument("bench")
argparser.add_argument("--outdir", default=".")

args = argparser.parse_args()
working_dir = os.getcwd() 
outdir = os.path.join(working_dir, args.outdir, 'sanitized')
os.makedirs(outdir, exist_ok=True)
Sanitizer(args.bench, 4, outdir).run()


