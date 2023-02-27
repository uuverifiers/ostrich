#import webserver.views.jsonview
#import webserver.views.PNGView
#import webserver.views.TextView
import requests



class ChartControllerJS:
    def __init__(self,result):
        self._result = result




    def gatherCactusData(self,params):
        rdata = requests.get('http://localhost:8081/chart/cactus').json()
        cactusData = dict()

        for s in rdata: 
            cactusData[s] = []
            for instance in rdata[s]:
                cactusData[s] += [instance["y"]]

        return cactusData

    def generateCactus(self,params):
        cactusData = self.gatherCactusData("")

        print("series: [")
        for s in cactusData:
            print(str(cactusData[s]) + ",")
        print("]")


    def gatherResultClassificationData(self,params):
        rdata = requests.get('http://localhost:8081/chart/cactus').json()
        cactusData = dict()

        for s in rdata: 
            cactusData[s] = []
            for instance in rdata[s]:
                cactusData[s] += [instance["y"]]

        return cactusData



    def generateDistribution (self,params):
        return None

            



d = ChartControllerJS("")
d.generateCactus("")