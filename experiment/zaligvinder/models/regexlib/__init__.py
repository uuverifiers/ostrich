def getTrackData (bname = None):
    import models.regexlib.large
    import models.regexlib.small
    res = []
    for k in [
    		  models.regexlib.large,
    		  models.regexlib.small,
              ]:
        res = res+k.getTrackData (bname or "regexlib")
    return res
