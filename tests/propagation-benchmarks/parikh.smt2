(set-logic QF_S)
(set-info :status unsat)

(declare-fun x () String)
(assert (= (str.++ x x "b" x)(str.++ x "a" x x)))
(check-sat)

(exit)
