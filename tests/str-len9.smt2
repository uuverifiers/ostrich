(set-logic QF_)

(declare-fun x () String)
(assert (= 1 (str.len x)))
(assert (str.<= "" x))
(check-sat)
