(set-logic QF_S)
(set-info :status sat)
(declare-const x String)


(assert (= x "cdeabcdcde"))
(assert (str.in.re x (re.* (re.union (str.to.re "abcd") (str.to.re "cde") ) ) ) )



(check-sat)
(get-model)

