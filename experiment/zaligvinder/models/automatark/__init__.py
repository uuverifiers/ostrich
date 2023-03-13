def getTrackData (bname = None):
    import models.automatark.large
    import models.automatark.small
    res = []
    for k in [
    		  models.automatark.large,
    		  models.automatark.small,
              ]:
        res = res+k.getTrackData (bname or "automatark")
    return res
