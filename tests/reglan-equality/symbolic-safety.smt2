(set-logic QF_S)
(set-info :status unsat)

(declare-const r RegLan)

; currently returns unknown
(assert (= r (str.to_re "a")))
(assert (= r (str.to_re "b")))

(check-sat)
