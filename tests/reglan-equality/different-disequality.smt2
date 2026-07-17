(set-logic QF_S)
(set-info :status sat)

(assert (distinct (str.to_re "a") (str.to_re "b")))

(check-sat)
