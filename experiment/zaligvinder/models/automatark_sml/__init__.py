def getTrackData (bname = None):
    import models.automatark_sml.complexnew
    import models.automatark_sml.simplenew
    res = []
    for k in [
    		  models.automatark_sml.complexnew,
    		  models.automatark_sml.simplenew,
              ]:
        res = res+k.getTrackData (bname or "automatark_sml")
    return res
