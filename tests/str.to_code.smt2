(set-logic QF_SLIA)

(declare-const n Int)

(assert (= n (str.to_code "")))
(assert (>= n 0))

(check-sat)
