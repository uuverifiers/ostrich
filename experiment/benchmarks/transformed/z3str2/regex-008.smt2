(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (str.to.re "abc") ) )



(check-sat)
(get-model)

