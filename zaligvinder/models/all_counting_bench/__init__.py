def getTrackData (bname = None):
    import models.all_counting_bench.automatarklen
    import models.all_counting_bench.generated
    res = []
    for k in [
    		  models.all_counting_bench.automatarklen,
    		  models.all_counting_bench.generated,
              ]:
        res = res+k.getTrackData (bname or "all_counting_bench")
    return res
