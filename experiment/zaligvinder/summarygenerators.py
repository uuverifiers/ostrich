import matplotlib.pyplot as plt
from itertools import accumulate
import tabulate
import json

def calculateErrors (track,res):
    instances = track.instances
    errors = {}
    for solver, mres in res.items ():
        errors[solver] = 0
        for i,k in enumerate(mres):
            inst = instances[i]
            if k.result != None: #inst.expected != None and k.result != None:
                # count and error if the expected result differs or an invalid model was produced
                if inst.expected != k.result or k.verified == False:
                    errors[solver]+=1
                # Count as error if a solver produced a wrong model
                if inst.expected == k.result and k.verified == False:
                    errors[solver]+=1
    return errors

def calculateErrorsOld(res):
    errors = dict()

    for solver in res.keys():
            errors[solver] = 0

            # pick an instance
            for i in range(len(res[solver])):
                myResult = res[solver][i].result

                # no judgement if unknown
                if myResult == None:
                    continue

                returnValues = [myResult]

                # collect the other results
                for other_solver in res.keys():
                    if other_solver == solver:
                        continue
                    returnValues+=[res[other_solver][i].result]

                # Majority vote
                result = None
                choices = [0,0]

                for b in returnValues:
                    if b == True:
                        choices[0]+=1
                    elif b == False:
                        choices[1]+=1

                if max(choices) > 0:
                    if choices.index(max(choices)) == 0 or (choices[0] != 0 and not (len(satTools) == 1 and "sloth" in satTools)):
                        result = True
                    else:
                        result = False
                else:
                    result = None

                if myResult != result:
                    errors[solver]+=1

    return errors

def terminalResult (track,res):
    name,files = track.name,track.instances
    print ("Track: " + str(track))
    table = []
    errors = calculateErrors(track,res)
    for n in res.keys():
        smtcalls = sum([i.smtcalls for i in res[n]])
        sat = sum([1 for i in res[n] if True == i.result])
        nsat = sum([1 for i in res[n] if False == i.result])
        unk = sum([1 for i in res[n] if None == i.result and i.timeouted != True])   
        to = sum([1 for i in res[n] if None == i.result and i.timeouted == True])
        t = sum([i.time for i in res[n] ])
        two = sum([i.time for i in res[n] if i.timeouted != True])
        #cort = sum([i[0][1] for i in zip([(j.result,j.time) for j in res[n]],ref) if i[0][0] == i[1] and i[1] != None])
        error = errors[n] 
        table.append ([n,sat,nsat,unk,to,error,smtcalls,t,two])
    print(tabulate.tabulate(table,["Solver", "Satis", "NSatis", "Unknown", "Timeout", "Errors",  "SMT Solver Calls", "Total Time", "Total Time w/o Timeout"]))

def cactusPlot (track,res):
    name,files = track.name,track.instances
    for p in res.keys():
        data = [i[1] for i in res[p]]
        data.sort()
        data = list(accumulate(data))
        plt.scatter (range(0,len(data)),data,label = p)

    plt.title (name)
    plt.legend (loc='upper left')
    plt.savefig ("{0}-cactus.png".format(name))
    plt.close()

class JSONOutputter:
    def __init__(self,loc = "hh"):
        self._data = []
        self._name = loc

    def __call__ (self,track,res):
        name,files = track
        self._data.append((name,res))

    def writeout (self):
        f = open (self._name+".json",'w')
        json.dump (self._data,f)

def timePlot (name,res):
    pass
