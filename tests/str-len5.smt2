(set-logic QF_)

(declare-fun x () String)

(assert (= 4 (str.len x)))
(assert (str.<= x "cba"))
(check-sat)
