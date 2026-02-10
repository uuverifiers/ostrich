; Problem for which Ostrich previously return sat.
; The formula is actually unsat.

(set-logic ALL)
(assert
  (forall ((char String))
    (=> (str.contains char ":")
        (str.contains char "://"))))
(check-sat)