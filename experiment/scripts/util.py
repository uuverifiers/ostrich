import re

def regexesCountStr(fileContent: str):
    LOOP_RE = re.compile(r'\(_ re.loop \d+ (\d+)\)', re.MULTILINE)
    loopMaxCounts = {}
    loopMaxs = LOOP_RE.findall(fileContent)
    for loopMax in loopMaxs:
        updateMaxCounts(loopMaxCounts, parseCountString(loopMax))
    maxCountSum = sum(loopMaxCounts.keys())
    return (int(maxCountSum > 50), int(len(loopMaxs) > 0), loopMaxCounts)

def updateMaxCounts(maxCounts: 'dict[int, int]', newMaxCounts: 'dict[int, int]'):
    """update maxCounts with newMaxCounts

    Args:
        maxCounts (dict[int, int]): The maxCounts to update
        newMaxCounts (dict[int, int]): The new maxCounts to update with
    """
    for (max, count) in newMaxCounts.items():
        if (max in maxCounts):
            maxCounts[max] += count
        else:
            maxCounts[max] = count

def parseCountString(count: str):
    if (count == ''):
        return {}
    else:
        return {int(count): 1}

def regexesCount(filename: str):
    f = open(filename, "r", encoding="utf8")
    fileContent = f.read()
    f.close()
    return regexesCountStr(fileContent)
