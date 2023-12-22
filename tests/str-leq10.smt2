(set-logic QF_SLIA)

(declare-fun x () String)
(assert (= "abc" x))
(assert (str.<= "b" x))
(check-sat)
