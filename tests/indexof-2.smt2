(set-logic QF_SLIA)

; UNSAT

(declare-fun x0 () String)
(declare-fun n () Int)

(assert (str.prefixof "testtesttest" x0))
(assert (= (str.indexof x0 "testtest" 0) n))
(assert (> n 0))

(check-sat)
