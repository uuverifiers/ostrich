(set-logic QF_S)
(set-info :status unsat)

(declare-const r RegLan)

(assert (= r (str.to_re "a")))
(assert (str.in_re "c" (re.union r (str.to_re "b"))))

(check-sat)
