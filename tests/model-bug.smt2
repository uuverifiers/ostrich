
(declare-const x String)
(assert (not (= x "")))
(check-sat)
(get-model)
