(set-logic QF_S)

(declare-const r RegLan)

(assert (distinct r (str.to_re "a")))

(check-sat)
