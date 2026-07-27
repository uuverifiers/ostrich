(set-logic QF_S)
(set-info :status unsat)

(declare-const r RegLan)

(assert (= r (str.to_re "a")))
(assert (str.in_re "b" r))

(check-sat)
