(set-logic QF_)

(declare-fun x () String)
(assert (= 1 (str.len x)))
(assert (str.<= "a" x))
(assert (str.<= x "c"))
(check-sat)
