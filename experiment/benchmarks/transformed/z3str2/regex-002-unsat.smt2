(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)
(declare-const y String)


(assert (= x "aaaaaaaaa"))
(assert (str.in.re x (re.* (str.to.re "ced") ) ) ) 



(check-sat)
(get-model)

