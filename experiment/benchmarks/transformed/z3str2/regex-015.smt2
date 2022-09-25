(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (str.to.re "ab12") ) ) )
(assert (str.in.re y (re.* (re.* (str.to.re "ab12") ) ) ) )

(assert (= (str.len x)  4) )
(assert (= (str.len y)  8) )

(check-sat)
(get-model)

