def getTrackData (bname = None):
    import models.fmcad.random2000fmcad
    res = []
    for k in [
    		  models.fmcad.random2000fmcad,
              ]:
        res = res+k.getTrackData (bname or "fmcad")
    return res
