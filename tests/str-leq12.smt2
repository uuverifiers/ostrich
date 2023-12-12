(set-logic QF_SLIA)

(declare-fun x () String)
(assert (= 1 (str.len x)))
(assert (str.<= "a" x))
(assert (str.<= x "b"))
(check-sat)
