(set-logic QF_S)
(set-info :status unsat)

(declare-const r RegLan)

; Conflicting aliases must be detected through re.from_id injectivity.
(assert (= r (str.to_re "a")))
(assert (= r (str.to_re "b")))

(check-sat)
