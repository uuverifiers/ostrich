(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (re.++ (re.* (str.to.re "a") ) (str.to.re "b") ))))

(assert (= (str.len x) 3))

(assert (not (= x "aab") ) )
(assert (not (= x "abb") ) )
(assert (not (= x "bab") ) )




(check-sat)
(get-model)

