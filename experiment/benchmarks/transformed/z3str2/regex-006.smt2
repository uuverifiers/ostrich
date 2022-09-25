(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (= x "abcabc"))
(assert (str.in.re x (re.* (re.* (str.to.re "abc") ) ) ) ) 



(check-sat)
(get-model)

