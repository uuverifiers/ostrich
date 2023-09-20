#!/bin/sh 

# This script will clean the database and remove all the data from the tables
BASEDIR=$(dirname $0)
DBDIR="${PWD}/${BASEDIR}"
rm $DBDIR/result_db/*.db
echo rm $DBDIR/result_db/*.db