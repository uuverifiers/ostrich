(set-logic QF_S)
(set-info :status unsat)

(assert (= (str.to_re "a") (str.to_re "b")))

(check-sat)
