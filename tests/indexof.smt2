(set-logic QF_S)

; SAT

(declare-fun x0 () String)
(declare-fun n () Int)

(assert (= (str.indexof x0 "===" 0) n))
(assert (> n 0))

(check-sat)
