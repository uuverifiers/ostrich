(set-logic QF_S)
(set-info :status unsat)

(assert
  (distinct (re.union (str.to_re "a") (str.to_re "b"))
            (re.range "a" "b")))

(check-sat)
