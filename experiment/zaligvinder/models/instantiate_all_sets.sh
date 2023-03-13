#!/bin/bash
for i in $(ls -d */); do cd ${i%%/}; ../init_models.sh; cd ..; done
