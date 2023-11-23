(set-logic QF_)

(declare-fun x () String)

(assert (= x "cbaa"))
(assert (str.<= x "cba"))
(check-sat)
