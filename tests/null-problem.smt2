; Problem that earlier crashed with the message "ERROR: null"

(define-fun z () String "10")
(define-fun y () String "010101")
(define-fun x () String "1001")

(assert (= x (str.replaceallre y (str.to.re "0101") z)))

(check-sat)
