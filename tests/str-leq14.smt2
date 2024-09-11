(set-logic QF_SLIA)

(declare-fun x () String)
(assert (str.in.re x (str.to.re "a")))
(assert (str.<= "abc" x))
(check-sat)
