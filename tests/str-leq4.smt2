(set-logic QF_SLIA)

(declare-fun x () String)

(assert (= x "cbaa"))
(assert (str.<= x "cba"))
(check-sat)
