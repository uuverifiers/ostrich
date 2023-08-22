def getTrackData (bname = None):
    import models.large_counting_bench.automatarklen
    import models.large_counting_bench.generated
    res = []
    for k in [
    		  models.large_counting_bench.automatarklen,
    		  models.large_counting_bench.generated,
              ]:
        res = res+k.getTrackData (bname or "large_counting_bench")
    return res
