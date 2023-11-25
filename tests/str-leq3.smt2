(set-logic QF_SLIA)

(declare-fun x () String)

(assert (= 1 (str.len x)))
(assert (str.<= x "cba"))
(check-sat)
