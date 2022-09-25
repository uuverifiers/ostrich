(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)


(assert (= (str.len x) 8))
(assert (str.in.re x (re.* (str.to.re "ced") ) ) ) 
(assert (str.in.re x (re.* (str.to.re "abcd") ) ) ) 


(check-sat)
(get-model)

