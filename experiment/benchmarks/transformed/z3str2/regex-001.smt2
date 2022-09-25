(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (= x ""))
(assert (str.in.re x (re.* (str.to.re "ced") ) ) ) 

(check-sat)
(get-model)

