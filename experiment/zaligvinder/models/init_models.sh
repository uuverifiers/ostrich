#! /bin/bash

declare -a dirs
i=1
for d in */
do
	if [[ ${d%/} =~ .*pycache.* ]]; then
    	echo 'stupid cache'
    else
    	dirs[i++]="${d%/}"
    fi
done



${VERSION//.}


benchmarkName=${PWD##*/} 

echo "There are ${#dirs[@]} dirs in the current path"

# mv benchmarks
for dir in "${dirs[@]}"
do
	tmpDir="${dir//-}"
	tmpDir2="${tmpDir//_}"
	tmpDir3="${tmpDir2//.}"

if [ "$dir" != "$tmpDir3" ]; then
	mv $dir $tmpDir3
fi
done 

# redefine dirs
declare -a dirs
i=1
for d in */
do
	if [[ ${d%/} =~ .*pycache.* ]]; then
    	echo 'stupid cache'
    else
    	dirs[i++]="${d%/}"
    fi
done



# create inner __init__.py
for dir in "${dirs[@]}"
do
rm $dir/__init__.py
touch $dir/__init__.py
echo 'import os' >> $dir/__init__.py
echo 'import utils' >> $dir/__init__.py
echo 'dir_path = os.path.dirname(os.path.realpath(__file__))' >> $dir/__init__.py
echo '' >> $dir/__init__.py
echo 'def getTrackData (bname = None):' >> $dir/__init__.py
echo '    filest = []' >> $dir/__init__.py
echo '    for root, dirs, files in os.walk(dir_path, topdown=False):' >> $dir/__init__.py
echo '        for name in files:' >> $dir/__init__.py
echo '            if (name.endswith (".smt2") or name.endswith(".smt") or name.endswith(".smt25")) and not name.startswith("."):' >> $dir/__init__.py
echo '                filest.append(utils.TrackInstance(name,os.path.join (root,name)))' >> $dir/__init__.py
echo '' >> $dir/__init__.py                
echo '    return [utils.Track("'${dir}'",filest,bname)]' >> $dir/__init__.py
done

# generate outer __init__.py
rm ./__init__.py
touch ./__init__.py

echo 'def getTrackData (bname = None):' >> ./__init__.py
for dir in "${dirs[@]}"
do
echo '    import models.'${benchmarkName}'.'${dir} >> ./__init__.py
done
echo '    res = []' >> ./__init__.py
echo '    for k in [' >> ./__init__.py
for dir in "${dirs[@]}"
do
echo '    		  models.'${benchmarkName}'.'${dir}',' >> ./__init__.py
done
echo '              ]:' >> ./__init__.py
echo '        res = res+k.getTrackData (bname or "'${benchmarkName}'")' >> ./__init__.py
echo '    return res' >> ./__init__.py

