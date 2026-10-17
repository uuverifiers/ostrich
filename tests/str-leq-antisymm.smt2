(set-logic QF_SLIA)

(declare-const s String)
(declare-const t String)

(assert (str.<= s t))
(assert (str.<= t s))
(assert (distinct s t))

(check-sat)
