(set-logic QF_S)
(set-info :status sat)

(declare-const r RegLan)

(assert (= r (str.to_re "a")))
(assert (str.in_re "a" r))

(check-sat)
