(set-logic QF_S)
(set-info :status unsat)

(assert
  (= re.none
     (re.inter (re.union (str.to_re "a") (str.to_re "b"))
               (re.range "a" "c"))))

(check-sat)
