(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (str.to.re "ab") ) ) )
(assert (str.in.re y (re.* (str.to.re "ab") ) ) )

(assert (= (str.len x)  2) )
(assert (= (str.len y)  4) )

(check-sat)
(get-model)

