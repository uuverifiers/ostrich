(set-logic QF_SLIA)

; SAT

(declare-fun x0 () String)
(declare-fun n () Int)

(assert (= (str.indexof x0 "===" 0) n))
(assert (> n 0))

(check-sat)
