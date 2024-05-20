(set-logic QF_SLIA)

(declare-fun x () String)

(assert (str.<= "cba" "cab"))
(check-sat)
