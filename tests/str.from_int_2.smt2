
(declare-const w String)

(assert (= w (int.to.str (- 42))))
(assert (not (= w "")))
(check-sat)
