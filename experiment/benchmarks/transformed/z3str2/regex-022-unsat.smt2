(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (re.++ (re.* (str.to.re "a") ) (str.to.re "b") ))))

(assert (= (str.len x) 2))

(assert (not (= x "bb")))
(assert (not (= x "ab")))


(check-sat)
(get-model)

