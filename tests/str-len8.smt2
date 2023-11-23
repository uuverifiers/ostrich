(set-logic QF_)

(declare-fun x () String)

(assert (str.<= "cba" "cab"))
(check-sat)
