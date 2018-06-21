(declare-fun x () String)
(declare-fun y () String)


(assert (str.in.re x (re.++ (str.to.re "ced") (re.* (str.to.re "ced") ) )) ) 
(assert (= x y))

(check-sat)

