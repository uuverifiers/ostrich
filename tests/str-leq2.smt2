(set-logic QF_SLIA)

(declare-fun x () String)

(assert (str.<= x ""))
(check-sat)
