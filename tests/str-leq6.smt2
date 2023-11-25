(set-logic QF_SLIA)

(declare-fun x () String)

(assert (= x "cab"))
(assert (str.<= x "cba"))
(check-sat)
