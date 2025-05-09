import json

class JSONView:
    def __init__ (self, data = []):
        self._text = json.dumps (data)
        
    def header (self,sendto):
        sendto.send_header ('Content-type','application/json')
        sendto.end_headers ()

    def response_code (self,sendto):
        sendto.send_response (200)

    def message (self,sendto):
        sendto.write (bytes(self._text,"utf8"))


