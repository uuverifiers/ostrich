import os
import re
import argparse


def cp_files_recursively(directory, out):
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if(is_large_count(file_path)):
                print(file_path)
                os.system(f"cp {file_path} {out}")
                out_file_path = os.path.join(out, file)
                os.system(f"sed -E -i 's/\(assert \(> \(str\.len X\) 10\)\)/\(assert \(< 200 \(str\.len X\)\)\)/g' {out_file_path}")
                os.system(f"sed -E -i 's/\(assert \(< 10 \(str\.len X\)\)\)/\(assert \(< 200 \(str\.len X\)\)\)/g' {out_file_path}")


def is_large_count(file):
    is_large = False
    try:
        with open(file, "r") as f:
            text = f.read()
            pattern = r'(_ re\.loop \d+ (\d+))'
            matches = re.findall(pattern, text, re.MULTILINE)
            for (match, number) in matches:
                if (int(number) > 50):
                    is_large = True
    except UnicodeDecodeError:
        pass
    finally:
        return is_large

argparser = argparse.ArgumentParser(
    prog=__file__, description="cp files with large counts recursively")
argparser.add_argument("directory")
argparser.add_argument("--out", default="large_counting_bench")
args = argparser.parse_args()
os.system(f"mkdir {args.out}")
cp_files_recursively(args.directory, args.out)
