(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)


;(assert (= x "abcdabcdabcdabcd"))
(assert (= x "abcdcde"))
(assert (str.in.re x (re.union (re.* (str.to.re "abcd") ) (re.* (str.to.re "cde") ) ) ) )



(check-sat)
(get-model)

