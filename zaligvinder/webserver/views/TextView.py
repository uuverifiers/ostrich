class TextView:
    def __init__ (self, text = 'DummyText'):
        self._text = text
        
    def header (self,sendto):
        sendto.send_header ('Content-type','text/html')
        sendto.end_headers ()

    def response_code (self,sendto):
        sendto.send_response (200)

    def message (self,sendto):
        #print (self._text)
        sendto.write (bytes(self._text,"utf8"))


class ErrorText:
    def __init__ (self, text = 'Error'):
        self._text = text
        
    def header (self,sendto):
        sendto.send_header ('Content-type','text/html')
        sendto.end_headers ()

    def response_code (self,sendto):
        sendto.send_response (400)

    def message (self,sendto):
        sendto.write (bytes(self._text,"utf8"))

