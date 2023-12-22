(set-logic QF_SLIA)

(declare-fun x () String)
(declare-fun y () String)

(assert (str.<= x y))

(check-sat)
