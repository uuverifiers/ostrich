(declare-fun x () String)
(declare-fun y () String)


(assert (= x "abcabc"))
(assert (str.in.re x (re.* (re.* (str.to.re "abc") ) ) ) ) 



(check-sat)

