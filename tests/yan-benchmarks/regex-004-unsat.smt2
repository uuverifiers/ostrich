(declare-fun x () String)


;(assert (= x "abcdabcdabcdabcd"))
(assert (= x "abcdcde"))
(assert (str.in.re x (re.union (re.* (str.to.re "abcd") ) (re.* (str.to.re "cde") ) ) ) )



(check-sat)

