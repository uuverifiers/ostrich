(set-logic QF_SLIA)

(assert (str.<= "abc" "abd"))
(assert (str.<= "abc" "abc"))
(check-sat)
