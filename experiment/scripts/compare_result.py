import glob, os, re
from dataclasses import dataclass, field

res_dir1 = "23-02-07_16:21:47z3str3re"
res_dir2 = "23-02-07_14:37:30unary"

dirname = os.path.dirname(__file__)
analyzed_file1 = glob.glob(f"{dirname}/../res/{res_dir1}/*_log.txt", recursive=True)[0]
analyzed_file2 = glob.glob(f"{dirname}/../res/{res_dir2}/*_log.txt", recursive=True)[0]

@dataclass
class ResultPartition:
  satfiles : list[str] = field(default_factory=list)
  unsatfiles : list[str] = field(default_factory=list)
  errorfiles : list[str] = field(default_factory=list)
  analyzed_file: str = ""
  
  def __post_init__(self) -> None:
    self.parse_res_file()
  
  def parse_single_result(self, result: str) -> None:
    INSTANCE_RE = re.compile("^Running \[(.*)\]", re.M)
    SAT_RE = re.compile("^sat", re.M)
    UNSAT_RE = re.compile("^unsat", re.M)
    instance = INSTANCE_RE.search(result).group(1)
    if SAT_RE.search(result):
      self.satfiles.append(instance)
    elif UNSAT_RE.search(result):
      self.unsatfiles.append(instance)
    else:
      self.errorfiles.append(instance)
    
  def parse_res_file(self) -> None:
    with open(self.analyzed_file, "r") as f:
      results = f.read().split("----splitter----")
      for result in results[:-1]:
        self.parse_single_result(result)
        
@dataclass
class Result1(ResultPartition):
  analyzed_file: str = analyzed_file1

@dataclass
class Result2(ResultPartition):
  analyzed_file: str = analyzed_file2
  
res1 = Result1()
res2 = Result2()

# print(res1.analyzed_file)
# print(res1.satfiles)

print("sat files diff:")
for file in set(res1.satfiles) ^ set(res2.satfiles):
  print(file)

print("unsat files diff:")
for file in set(res1.unsatfiles) ^ set(res2.unsatfiles):
  print(file)

  
  