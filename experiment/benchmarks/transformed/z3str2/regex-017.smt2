(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (re.union (str.to.re "AB") (re.union (str.to.re "abcd") (str.to.re "123") ) ) ) ) )

(assert (= 5 (str.len x)))


(check-sat)
(get-model)

