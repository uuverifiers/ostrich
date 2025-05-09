(set-logic QF_SLIA)

; SAT

(declare-fun x0 () String)
(declare-fun n () Int)

(assert (str.prefixof "testtesttest" x0))
(assert (= (str.indexof x0 "testtest" (- 1)) n))

(check-sat)
