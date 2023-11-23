(set-logic QF_)

(declare-fun x () String)

(assert (= x "cab"))
(assert (str.<= x "cba"))
(check-sat)
