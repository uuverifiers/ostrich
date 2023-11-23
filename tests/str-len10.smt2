(set-logic QF_)

(declare-fun x () String)
(assert (= "abc" x))
(assert (str.<= "b" x))
(check-sat)
