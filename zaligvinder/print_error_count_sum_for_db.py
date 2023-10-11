import os
import argparse
import storage.sqlitedb
import re

def error(db, solver):
    trackinstance_db = storage.sqlitedb.TrackInstanceRepository(db)
    track_db = storage.sqlitedb.TrackRepository(db, trackinstance_db)
    result_db = storage.sqlitedb.ResultRepository(
        db, track_db, trackinstance_db)
    error_files = result_db.getAllErrorFilesForSolver(solver)
    for file in error_files:
        print(file)

def unknown(db, solver):
    trackinstance_db = storage.sqlitedb.TrackInstanceRepository(db)
    track_db = storage.sqlitedb.TrackRepository(db, trackinstance_db)
    result_db = storage.sqlitedb.ResultRepository(
        db, track_db, trackinstance_db)
    unknown_files = result_db.getAllUnknownFilesForSolver(solver)
    for file in unknown_files:
        print(file)

def unsat(db, solver):
    trackinstance_db = storage.sqlitedb.TrackInstanceRepository(db)
    track_db = storage.sqlitedb.TrackRepository(db, trackinstance_db)
    result_db = storage.sqlitedb.ResultRepository(
        db, track_db, trackinstance_db)
    unsat_files = result_db.getAllUnsatFilesForSolver(solver)
    for file in unsat_files:
        print(file)

def timeout(db, solver):
    trackinstance_db = storage.sqlitedb.TrackInstanceRepository(db)
    track_db = storage.sqlitedb.TrackRepository(db, trackinstance_db)
    result_db = storage.sqlitedb.ResultRepository(
        db, track_db, trackinstance_db)
    timeout_files = result_db.getAllTimeoutFilesForSolver(solver)
    for file in timeout_files:
        print(file)

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
argparser.add_argument("--solver", default="ostrichCEA")
argparser.add_argument("--error", action=argparse.BooleanOptionalAction)
argparser.add_argument("--unknown", action=argparse.BooleanOptionalAction)
argparser.add_argument("--timeout", action=argparse.BooleanOptionalAction)
argparser.add_argument("--unsat", action=argparse.BooleanOptionalAction)
args = argparser.parse_args()
db = storage.sqlitedb.DB(args.database)
if(args.error):
    error(db, args.solver)
if(args.unknown):
    unknown(db, args.solver)
if(args.unsat):
    unsat(db, args.solver)
if(args.timeout):
    timeout(db, args.solver)