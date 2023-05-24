(set-logic QF_S)
(declare-const x String)
(declare-const y String)
(assert (str.in.re x (re.* (re.union (str.to.re "Qqqqa") (str.to.re "1111")))))
(assert (= 10 (str.len x)))
(assert (not (= x "1111Qqqqa")))
(check-sat)
(get-model)

