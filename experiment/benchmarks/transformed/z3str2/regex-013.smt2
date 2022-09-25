(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re y (re.* (re.* (str.to.re "abcd") ) ) ) )

(assert (= (str.len y)  8) )

(check-sat)
(get-model)

