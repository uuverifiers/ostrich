(set-logic QF_)

(declare-fun x () String)

(assert (str.<= x ""))
(check-sat)
