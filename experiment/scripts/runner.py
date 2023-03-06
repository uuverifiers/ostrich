from multiprocessing.dummy import Pool
import os
import glob
import subprocess
from tqdm import tqdm
from time import time
from dataclasses import dataclass, field

timelimit = 60
dirname = os.path.dirname(__file__)


@dataclass
# Interface to mutithreadingly run each file of a benchmark directory.
# The file extension should be specified.
class RunnerInterface:
    benchdir: str
    proccess_num: int
    outdir: str
    extension: str

    def __post_init__(self) -> None:
        self.benchmarks = glob.glob(
            f"{self.benchdir}/**/*{self.extension}", recursive=True
        )
        self.pbar = tqdm(total=len(self.benchmarks))

    def write_results(self, results: "list[str]"):
        pass

    def run_with_pbar_update(self, filename: str):
        self.pbar.update(1)
        return self.run_single_instance(filename)

    def run_single_instance(self, filename: str):
        pass

    def run(self):
        with Pool(processes=self.proccess_num) as pool:
            results = pool.map(
                self.run_with_pbar_update,
                self.benchmarks,
                chunksize=int(len(self.benchmarks) / self.proccess_num),
            )
            self.write_results(results)
        self.pbar.close()


@dataclass
class BaseLineRunner(RunnerInterface):
    extension: str = ".smt2"
    backend = "baseline"

    def write_results(self, results: "list[str]"):
        with open(os.path.join(self.outdir, f"{self.backend}_log.txt"), "w") as f:
            for result in results:
                f.write(f"{result}{os.linesep}")

    def run_single_instance(self, benchmark: str) -> str:
        str_result = []
        command = os.path.join(dirname, "../../ostrich")
        str_result.append(f"Running [{benchmark}]")
        self.pbar.set_description(f"Running [{benchmark}]")
        before_time = time() * 1000
        try:
            res = subprocess.run(
                [
                    command,
                    "+costenriched",
                    "+minimizeAutomata",
                    f"-backend={self.backend}",
                    "+incremental",
                    "-inputFormat=smtlib",
                    benchmark,
                ],
                timeout=timelimit,
                capture_output=True,
                encoding="utf-8",
            )
            str_result.append(res.stdout)
        except subprocess.TimeoutExpired:
            str_result.append(f"Timeout ")
        except Exception as e:
            str_result.append(f"Exception: {e}")
        after_time = time() * 1000
        str_result.append(f"Time: {after_time - before_time} ms")
        str_result.append(f"----splitter----")
        return os.linesep.join(str_result)


class UnaryRunner(BaseLineRunner):
    backend = "unary"


class CatraRunner(BaseLineRunner):
    backend = "catra"


@dataclass
class Z3Runner(RunnerInterface):
    extension: str = "smt2"
    backend = "z3"
    command: list[str] = field(default_factory=list)

    def __post_init__(self) -> None:
        super().__post_init__()
        self.command = ["z3"]

    def write_results(self, results: "list[str]"):
        with open(os.path.join(self.outdir, f"{self.backend}_log.txt"), "w") as f:
            for result in results:
                f.write(f"{result}{os.linesep}")

    def run_single_instance(self, benchmark: str) -> str:
        str_result = []
        str_result.append(f"Running [{benchmark}]")
        before_time = time() * 1000
        try:
            result = subprocess.run(
                self.command + [benchmark],
                timeout=timelimit,
                capture_output=True,
                encoding="utf-8",
            )
            str_result.append(result.stdout)
            str_result.append(result.stderr)
        except subprocess.TimeoutExpired:
            str_result.append("Timeout")
        except Exception as e:
            str_result.append(f"Exception: {e}")
        after_time = time() * 1000
        str_result.append(f"Time: {after_time - before_time} ms")
        str_result.append(f"----splitter----")
        return os.linesep.join(str_result)


@dataclass
class CVC5Runner(Z3Runner):
    command: list[str] = field(default_factory=list)
    backend = "cvc5"

    def __post_init__(self) -> None:
        super().__post_init__()
        command_without_params = os.path.join(
            dirname, "../SolverBinaries/cvc5")
        self.command = [
            command_without_params,
            "--lang=smt2",
            "--produce-models"
        ]


@dataclass
class Z3Str3RERunner(Z3Runner):
    command: list[str] = field(default_factory=list)
    backend = "z3str3re"

    def __post_init__(self) -> None:
        super().__post_init__()
        command_without_params = os.path.join(
            dirname, "../SolverBinaries/RegExSolver/z3")
        self.command = [
            command_without_params,
            "smt.string_solver=z3str3",
            "smt.str.tactic=arr",
            "smt.arith.solver=2",
            "dump_models=true",
        ]


@dataclass
class Z3TrauRunner(Z3Runner):
    command: list[str] = field(default_factory=list)
    backend = "z3trau"

    def __post_init__(self) -> None:
        super().__post_init__()
        command_without_params = os.path.join(
            dirname, "../SolverBinaries/RegExSolver/z3")
        self.command = [
            command_without_params,
            "smt.string_solver=z3str3",
        ]
