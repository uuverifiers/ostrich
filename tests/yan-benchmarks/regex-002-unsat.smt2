(declare-fun x () String)
(declare-fun y () String)


(assert (= x "aaaaaaaaa"))
(assert (str.in.re x (re.* (str.to.re "ced") ) ) ) 



(check-sat)

