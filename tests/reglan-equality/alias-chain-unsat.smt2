(set-logic QF_S)
(set-info :status unsat)

(declare-const r RegLan)
(declare-const s RegLan)

(assert (= r s))
(assert (= s (str.to_re "a")))
(assert (= r (str.to_re "b")))

(check-sat)
