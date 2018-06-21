(declare-fun x () String)


(assert (= x "cdeabcdcde"))
(assert (str.in.re x (re.* (re.union (str.to.re "abcd") (str.to.re "cde") ) ) ) )



(check-sat)

