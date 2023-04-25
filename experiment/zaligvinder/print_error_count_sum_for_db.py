import os
import argparse
import storage.sqlitedb
import re


def parseCountString(count: str):
    if (count == ''):
        return {}
    else:
        return {int(count): 1}


def regexesCount(filename: str):
    f = open(filename, "r", encoding="utf8")
    LOOP_RE = re.compile(r"\(_ re.loop \d+ (\d+)\)", re.MULTILINE)
    content = f.read()
    allloop = re.findall(LOOP_RE, content)
    sum = 0
    for count in allloop:
        sum += int(count)
    print(filename)
    #   print(sum)
    f.close()


def unsolved(db, solver):
    trackinstance_db = storage.sqlitedb.TrackInstanceRepository(db)
    track_db = storage.sqlitedb.TrackRepository(db, trackinstance_db)
    result_db = storage.sqlitedb.ResultRepository(
        db, track_db, trackinstance_db)
    unsolved_files = result_db.getAllUnsolvedFilesForSolver(solver)
    for file in unsolved_files:
        regexesCount(file)
    return len(unsolved_files)


def unique(db):
    trackinstance_db = storage.sqlitedb.TrackInstanceRepository(db)
    track_db = storage.sqlitedb.TrackRepository(db, trackinstance_db)
    result_db = storage.sqlitedb.ResultRepository(
        db, track_db, trackinstance_db)
    unique_files = result_db.getUniquelyClassifiedInstances()
    for key in unique_files:
        print(key)
        for file in unique_files[key]:
            print(file)

argparser = argparse.ArgumentParser(
    prog=__file__, description="count the sum of repetition times in the error instances of a database")
argparser.add_argument("database")
args = argparser.parse_args()
db = storage.sqlitedb.DB(args.database)
unsolved_num = unsolved(db, "ostrich")

# unique(db)