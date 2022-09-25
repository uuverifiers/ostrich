(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (str.to.re "abcd") ) ) )
(assert (str.in.re y (re.* (str.to.re "abcd") ) ) )

(assert (= (str.len x)  6) )

(check-sat)
(get-model)

