import os
import utils
dir_path = os.path.dirname(os.path.realpath(__file__))

def getTrackData (bname = None):
    filest = []
    for root, dirs, files in os.walk(dir_path, topdown=False):
        for name in files:
            if (name.endswith (".smt2") or name.endswith(".smt") or name.endswith(".smt25")) and not name.startswith("."):
                filest.append(utils.TrackInstance(name,os.path.join (root,name)))

    return [utils.Track("simplenew",filest,bname)]
