(set-logic QF_SLIA)

(assert (str.<= "a" "b"))
(assert (str.<= "a" "a"))
(check-sat)
