(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (str.to.re "abcd") ) ) )
(assert (str.in.re x (re.* (str.to.re "abcdabcd") ) ) )

(assert (> (str.len x) 20) )

(assert (< (str.len x) 25) )

(check-sat)
(get-model)

