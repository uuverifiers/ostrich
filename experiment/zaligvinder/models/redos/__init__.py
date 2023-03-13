def getTrackData (bname = None):
    import models.redos.large
    import models.redos.small
    res = []
    for k in [
    		  models.redos.large,
    		  models.redos.small,
              ]:
        res = res+k.getTrackData (bname or "redos")
    return res
