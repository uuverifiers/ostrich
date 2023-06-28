(define-fun sigmaStar_048 () String "Ajavascript:")
(define-fun x_7 () String "javascript:")
(assert (= x_7 (str.replace_re sigmaStar_048 re.allchar "") ) )
(check-sat)
